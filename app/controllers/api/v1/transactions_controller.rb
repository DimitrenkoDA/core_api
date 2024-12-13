module API
  module V1
    class TransactionsController < ApplicationController
      def show
        handler = ::Transactions::Handlers::Show.new(self)
        handler.handle!
      end

      def index
        handler = ::Transactions::Handlers::Index.new(self)
        handler.handle!
      end
    end
  end
end
