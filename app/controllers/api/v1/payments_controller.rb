module API
  module V1
    class PaymentsController < ApplicationController
      def show
        handler = ::Payments::Handlers::Show.new(self)
        handler.handle!
      end

      def search
        handler = ::Payments::Handlers::Search.new(self)
        handler.handle!
      end

      def create
        handler = ::Payments::Handlers::Create.new(self)
        handler.handle!
      end

      def update
        handler = ::Payments::Handlers::Update.new(self)
        handler.handle!
      end
    end
  end
end
