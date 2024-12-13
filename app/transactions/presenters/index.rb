module Transactions
  module Presenters
    class Index < ApplicationPresenter
      attr_reader :transactions

      def initialize(transactions)
        @transactions = transactions
      end

      def as_json(options = {})
        {
          params: options.fetch(:params, {}),
          transactions: transactions.map do |transaction|
            Transactions::Presenters::Show.new(transaction).as_json(options)
          end
        }
      end
    end
  end
end
