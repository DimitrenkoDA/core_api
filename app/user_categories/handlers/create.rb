module UserCategories
  module Handlers
    class Create < ApplicationHandler
      params do
        required(:user_id).filled(:integer)
      end

      payload do
        required(:name).filled(:string)
        required(:kind).filled(:string, included_in?: UserCategory.kinds.keys)
        required(:colour_code).filled(:string, format?: /\A#[0-9a-fA-F]+\z/)

        optional(:description).filled(:string)
      end

      def handle
        authorize!

        category = UserCategory.new(
          user: user,
          name: payload[:name],
          kind: payload[:kind],
          colour_code: payload[:colour_code]
        )

        category.description = payload[:description] if payload.key?(:description)
        category.save!

        render status: 200 do
          json { UserCategories::Presenters::Show.new(category).as_json(user: true) }
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
