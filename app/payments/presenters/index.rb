module Payments
  module Presenters
    class Index < ApplicationPresenter
      attr_reader :payments

      def initialize(payments)
        @payments = payments
      end

      def as_json(options = {})
        {
          params: options.fetch(:params, {}),
          payments: payments.map do |payment|
            Payments::Presenters::Show.new(payment).as_json(options)
          end
        }
      end
    end
  end
end
