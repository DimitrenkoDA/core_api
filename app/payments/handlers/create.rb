module Payments
  module Handlers
    class Create < ApplicationHandler
      params do
        required(:user_id).filled(:integer)
      end

      payload do
        required(:amount).hash do
          required(:value).filled(:float, gt?: 0.0)
          required(:currency).filled(:string)
        end

        optional(:created_at).filled(:date_time)
        optional(:note).filled(:string)
        optional(:category_ids).array(:integer)
      end

      def handle
        authorize!

        if Money::Currency.find(payload[:amount][:currency]).nil?
          render status: 422 do
            json { Errors::Error.alert("Unknown currency received: #{payload[:amount][:currency]}") }
          end

          return
        end

        payment = ActiveRecord::Base.transaction do
          amount = Money.from_amount(payload[:amount][:value], payload[:amount][:currency])

          payment = Payment.new(
            user: user,
            amount: amount,
            note: payload[:note],
            created_at: params[:created_at] || Time.zone.now
          )

          transaction = Transaction.create!(user: user, amount: amount * -1)

          payment.balance_transaction = transaction

          if payload[:category_ids].present?
            payment.categories << user.categories.where(id: payload[:category_ids])
          end

          payment.save!

          calculator = Users::BalanceCalculator.new(user)
          calculator.calculate

          payment
        end

        render status: 200 do
          json { Payments::Presenters::Show.new(payment).as_json(categories: true) }
        end
      end

      private def user
        @user ||= User.find(params[:user_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(user)

        access_denied!
      end
    end
  end
end
