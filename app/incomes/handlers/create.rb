module Incomes
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

        income = ActiveRecord::Base.transaction do
          amount = Money.from_amount(payload[:amount][:value], payload[:amount][:currency])

          income = Income.new(user: user, amount: amount, note: payload[:note])

          transaction = Transaction.create!(user: user, amount: amount)

          income.balance_transaction = transaction

          if payload[:category_ids].present?
            income.categories << user.categories.where(id: payload[:category_ids])
          end

          income.save!

          calculator = Users::BalanceCalculator.new(user)
          calculator.calculate

          income
        end

        render status: 200 do
          json { Incomes::Presenters::Show.new(income).as_json(categories: true) }
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
