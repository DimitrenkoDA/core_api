module API
  module V1
    class UserCategoriesController < ApplicationController
      def show
        handler = ::UserCategories::Handlers::Show.new(self)
        handler.handle!
      end

      def index
        handler = ::UserCategories::Handlers::Index.new(self)
        handler.handle!
      end

      def search
        handler = ::UserCategories::Handlers::Search.new(self)
        handler.handle!
      end

      # def create
      #   handler = ::UserCategories::Handlers::Create.new(self)
      #   handler.handle!
      # end
      #
      # def update
      #   handler = ::UserCategories::Handlers::Update.new(self)
      #   handler.handle!
      # end
      #
      # def archive
      #   handler = ::UserCategories::Handlers::Archive.new(self)
      #   handler.handle!
      # end
    end
  end
end
