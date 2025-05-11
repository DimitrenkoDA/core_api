module API
  module V1
    class TransactionsController < ApplicationController
      def show
        handler = ::Transactions::Handlers::Show.new(self)
        handler.handle!
      end
    end
  end
end
