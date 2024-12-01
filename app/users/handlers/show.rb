module Users
  module Handlers
    class Show < ApplicationHandler
      params do
        required(:user_id).filled(:integer)
      end

      def handle
        authorize!

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
