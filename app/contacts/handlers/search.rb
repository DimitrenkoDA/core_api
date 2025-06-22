module Contacts
  module Handlers
    class Search < ApplicationHandler
      params do
        required(:user_id).filled(:integer)
      end

      payload do
        optional(:query).maybe(:string)

        optional(:limit).filled(:integer, gteq?: 0, lteq?: ApplicationRecord::MAX_LIMIT)
        optional(:offset).filled(:integer, gteq?: 0)
      end

      def handle
        authorize!

        contacts = user.owned_contacts.joins(:user)

        if payload[:query].present?
          contacts = contacts.where(
            "users.email ILIKE :query OR users.first_name ILIKE :query OR users.last_name ILIKE :query",
            query: "%#{ApplicationRecord.sanitize_sql_like(payload[:query])}%"
          )
        end

        contacts = contacts.order("users.email").limit(limit).offset(offset)

        render status: 200 do
          json { Contacts::Presenters::Index.new(contacts).as_json(params: params) }
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
        payload[:limit] || ApplicationRecord::DEFAULT_LIMIT
      end

      private def offset
        payload[:offset] || 0
      end
    end
  end
end
