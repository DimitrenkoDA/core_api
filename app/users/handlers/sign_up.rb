module Users
  module Handlers
    class SignUp < ApplicationHandler
      payload do
        required(:email).filled(:string)
        required(:password).filled(:string)
        required(:password_confirmation).filled(:string)

        optional(:first_name).filled(:string)
        optional(:last_name).filled(:string)
        optional(:birth_date).filled(:date_time)
      end

      def handle
        if User.exists?(email: payload[:email])
          render status: 422 do
            json { Errors::Error.alert("User already registered") }
          end

          return
        end

        if payload[:password] != payload[:password_confirmation]
          render status: 422 do
            json { Errors::Error.alert("Passwords do not match") }
          end

          return
        end

        user = User.new(
          email: payload[:email],
          password: payload[:password],
          password_confirmation: payload[:password_confirmation]
        )

        user.first_name = payload[:first_name] if payload.key?(:first_name)
        user.last_name = payload[:last_name] if payload.key?(:last_name)
        user.birth_date = payload[:birth_date] if payload.key?(:birth_date)

        user.save!

        render status: 200 do
          json { Users::Presenters::Show.new(user).as_json }
        end
      end
    end
  end
end
