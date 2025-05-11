module Payments
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :payment

      def initialize(payment)
        @payment = payment
      end

      def as_json(options = {})
        json = {
          id: payment.id,
          user_id: payment.user_id,
          amount: money(payment.amount),
          created_at: timestamp(payment.created_at),
          updated_at: timestamp(payment.updated_at),
        }

        if payment.categories.present? && options.fetch(:categories, false)
          json[:categories] = payment.categories.map do |category|
            ::UserCategories::Presenters::Show.new(category).as_json
          end
        end

        json
      end
    end
  end
end
