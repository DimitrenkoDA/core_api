module UserCategories
  module Handlers
    class Search < ApplicationHandler
      payload do
        required(:user_id).filled(:integer)

        optional(:query).maybe(:string)
        optional(:kinds).array(:string, included_in?: UserCategory.kinds.keys)

        optional(:limit).filled(:integer, gteq?: 0, lteq?: ApplicationRecord::MAX_LIMIT)
        optional(:offset).filled(:integer, gteq?: 0)
      end

      def handle
        authorize!

        categories = user.categories
        categories = categories.where(kind: params[:kind]) if payload.key?(:kind)

        if payload[:query].present?
          categories = categories.where(
            "id::text LIKE :query OR name ILIKE :query OR colour_code ILIKE :query",
            query: "%#{ApplicationRecord.sanitize_sql_like(payload[:query])}%"
          )
        end

        categories = categories.order(created_at: :desc).limit(limit).offset(offset)

        render status: 200 do
          json { UserCategories::Presenters::Index.new(categories).as_json(params: payload) }
        end
      end

      private def user
        @user ||= User.find(payload[:user_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(user)

        access_denied!
      end

      private def limit
        payload[:limit] || ApplicationRecord::DEFAULT_LIMIT
      end

      private def offset
        payload[:offset] || 0
      end
    end
  end
end
