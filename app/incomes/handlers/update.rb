module Incomes
  module Handlers
    class Update < ApplicationHandler
      params do
        required(:income_id).filled(:integer)
      end

      payload do
        optional(:amount).hash do
          required(:value).filled(:float, gt?: 0.0)
          required(:currency).filled(:string)
        end

        optional(:created_at).filled(:date_time)
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

          income.amount = amount
        end

        if payload.key?(:created_at)
          income.created_at = payload[:created_at]
        end

        if payload.key?(:note)
          if payload[:note].present?
            income.note = payload[:note]
          else
            income.note = nil
          end
        end

        if payload.key?(:category_ids)
          income.categories.clear

          if payload[:category_ids].present?
            income.categories << income.user.categories.where(id: payload[:category_ids])
          end
        end

        income.save!

        if income.balance_transaction.amount != income.amount
          income.balance_transaction.update!(amount: income.amount)

          calculator = Users::BalanceCalculator.new(income.user)
          calculator.calculate
        end

        render status: 200 do
          json { Incomes::Presenters::Show.new(income).as_json(categories: true) }
        end
      end

      private def income
        @income ||= Income.find(params[:income_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(income.user)

        access_denied!
      end
    end
  end
end
