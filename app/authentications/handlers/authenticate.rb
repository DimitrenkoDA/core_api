module Authentications
  module Handlers
    class Authenticate < ApplicationHandler
      params do
        required(:authentication_id).filled(:string)
      end

      payload do
        required(:step).filled(:string, included_in?: Authentication.steps.keys)
        required(:data).filled(:hash)
      end

      def handle
        authentication = Authentication.find_by(id: params[:authentication_id])

        if authentication.nil?
          render status: 422 do
            json { Errors::Error.alert("Credentials are invalid") }
          end

          return
        end

        if authentication.expired? || authentication.complete?
          render status: 422 do
            json { Errors::Error.alert("Authentication is expired") }
          end

          return
        end

        authenticator = if authentication.password?
                          Authentications::Authenticators::Password.new(authentication)
                        else
                          raise UnknownAuthenticationStep, "Authentication step #{authentication.step} is unknown"
                        end

        authentication = authenticator.authenticate(payload[:data].deep_symbolize_keys)

        if authentication.nil?
          render status: 422 do
            json { Errors::Error.alert("Credentials are invalid") }
          end

          return
        end

        render status: 200 do
          json { Authentications::Presenters::Show.new(authentication) }
        end
      end
    end
  end
end
