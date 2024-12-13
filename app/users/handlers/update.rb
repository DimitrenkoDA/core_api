module Users
  module Handlers
    class Update < ApplicationHandler
      params do
        required(:user_id).filled(:string)
      end

      payload do
        optional(:first_name).filled(:string)
        optional(:last_name).filled(:string)
        optional(:birth_date).filled(:date_time)
      end

      def handle
        authorize!

        user.first_name = payload[:first_name] if payload.key?(:first_name)
        user.last_name = payload[:last_name] if payload.key?(:last_name)
        user.birth_date = payload[:birth_date] if payload.key?(:birth_date)

        user.save!

        render status: 200 do
          json { Users::Presenters::Show.new(user).as_json }
        end
      end

      private def user
        @user ||= User.find(params[:user_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(user)

        access_denied!
      end
    end
  end
end
