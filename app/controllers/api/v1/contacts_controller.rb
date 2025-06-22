module API
  module V1
    class ContactsController < ApplicationController
      def show
        handler = ::Contacts::Handlers::Show.new(self)
        handler.handle!
      end

      def search
        handler = ::Contacts::Handlers::Search.new(self)
        handler.handle!
      end

      def create
        handler = ::Contacts::Handlers::Create.new(self)
        handler.handle!
      end

      def destroy
        handler = ::Contacts::Handlers::Destroy.new(self)
        handler.handle!
      end
    end
  end
end
