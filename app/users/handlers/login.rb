module Users
  module Handlers
    class Login < ApplicationHandler
      payload do
        required(:email).filled(:string)
      end

      def handle
        rider = User.find_by(email: payload[:email])

        if rider.nil?
          render status: 422 do
            json { Errors::Error.alert("Credentials are invalid") }
          end

          return
        end

        builder = Authentications::Builder.new(rider)
        authentication = builder.password

        render status: 200 do
          json { Authentications::Presenters::Show.new(authentication) }
        end
      end

      private def randomizer
        @randomizer ||= Random.new
      end
    end
  end
end
