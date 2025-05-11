module Payments
  module Handlers
    class Update < ApplicationHandler
      params do
        required(:payment_id).filled(:integer)
      end

      payload do
        optional(:amount).hash do
          required(:value).filled(:float, gt?: 0.0)
          required(:currency).filled(:string)
        end

        optional(:note).maybe(:string)
        optional(:category_ids).array(:integer)
      end

      def handle
        authorize!

        if payload.key?(:amount)
          if Money::Currency.find(payload[:amount][:currency]).nil?
            render status: 422 do
              json { Errors::Error.alert("Unknown currency received: #{payload[:amount][:currency]}") }
            end

            return
          end

          amount = Money.from_amount(payload[:amount][:value], payload[:amount][:currency])

          payment.amount = amount
        end

        if payload.key?(:note)
          if payload[:note].present?
            payment.note = payload[:note]
          else
            payment.note = nil
          end
        end

        if payload.key?(:category_ids)
          payment.categories.clear

          if payload[:category_ids].present?
            payment.categories << payment.user.categories.where(id: payload[:category_ids])
          end
        end

        payment.save!

        if payment.balance_transaction.amount != payment.amount * -1
          payment.balance_transaction.update!(amount: payment.amount * -1)

          calculator = Users::BalanceCalculator.new(payment.user)
          calculator.calculate
        end

        render status: 200 do
          json { Payments::Presenters::Show.new(payment).as_json(categories: true) }
        end
      end

      private def payment
        @payment ||= Payment.find(params[:payment_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(payment.user)

        access_denied!
      end
    end
  end
end
