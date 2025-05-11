module API
  module V1
    class IncomesController < ApplicationController
      def show
        handler = ::Incomes::Handlers::Show.new(self)
        handler.handle!
      end

      def search
        handler = ::Incomes::Handlers::Search.new(self)
        handler.handle!
      end

      def create
        handler = ::Incomes::Handlers::Create.new(self)
        handler.handle!
      end

      def update
        handler = ::Incomes::Handlers::Update.new(self)
        handler.handle!
      end
    end
  end
end
