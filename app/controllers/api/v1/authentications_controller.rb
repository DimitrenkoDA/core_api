module API
  module V1
    class AuthenticationsController < ApplicationController
      def authenticate
        handler = ::Authentications::Handlers::Authenticate.new(self)
        handler.handle!
      end
    end
  end
end
