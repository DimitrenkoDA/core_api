module API
  module V1
    class UsersController < ApplicationController
      def login
        handler = ::Users::Handlers::Login.new(self)
        handler.handle!
      end

      def sign_up
        handler = ::Users::Handlers::SignUp.new(self)
        handler.handle!
      end

      def show
        handler = ::Users::Handlers::Show.new(self)
        handler.handle!
      end

      def update
        handler = ::Users::Handlers::Update.new(self)
        handler.handle!
      end
    end
  end
end
