module UserCategories
  module Handlers
    class Index < ApplicationHandler
      params do
        required(:user_id).filled(:integer)

        optional(:kinds).array(:string, included_in?: UserCategory.kinds.keys)

        optional(:limit).filled(:integer, gteq?: 0, lteq?: ApplicationRecord::MAX_LIMIT)
        optional(:offset).filled(:integer, gteq?: 0)
      end

      def handle
        authorize!

        categories = user.categories
        categories = categories.where(kind: params[:kind]) if params.key?(:kind)

        categories = categories.order(created_at: :desc).limit(limit).offset(offset)

        render status: 200 do
          json { UserCategories::Presenters::Index.new(categories).as_json(params: params) }
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

      private def limit
        params[:limit] || ApplicationRecord::DEFAULT_LIMIT
      end

      private def offset
        params[:offset] || 0
      end
    end
  end
end
