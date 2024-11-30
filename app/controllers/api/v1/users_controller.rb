module API
  module V1
    class UsersController < ApplicationController
      def login
        handler = ::Users::Handlers::Login.new(self)
        handler.handle!
      end
    end
  end
end
