module API
  module V1
    class UserCategoriesController < ApplicationController
      def show
        handler = ::UserCategories::Handlers::Show.new(self)
        handler.handle!
      end

      def search
        handler = ::UserCategories::Handlers::Search.new(self)
        handler.handle!
      end

      def create
        handler = ::UserCategories::Handlers::Create.new(self)
        handler.handle!
      end

      def update
        handler = ::UserCategories::Handlers::Update.new(self)
        handler.handle!
      end

      def destroy
        handler = ::UserCategories::Handlers::Destroy.new(self)
        handler.handle!
      end
    end
  end
end
