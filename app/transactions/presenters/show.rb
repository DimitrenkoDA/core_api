module Transactions
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :transaction

      def initialize(transaction)
        @transaction = transaction
      end

      def as_json(options = {})
        json = {
          id: transaction.id,
          polarity: transaction.polarity,
          amount: money(transaction.amount),
          created_at: timestamp(transaction.created_at),
          updated_at: timestamp(transaction.updated_at),
        }

        if options.fetch(:user, false)
          json[:user] = Users::Presenters::Show.new(transaction.user).as_json
        end

        json
      end
    end
  end
end
