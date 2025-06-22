module Contacts
  module Handlers
    class Create < ApplicationHandler
      params do
        required(:user_id).filled(:integer)
      end

      payload do
        required(:associated_id).filled(:integer)
      end

      def handle
        authorize!

        contact = owner.owned_contacts.find_or_create_by!(user_id: associated.id)

        render status: 200 do
          json { Contacts::Presenters::Show.new(contact).as_json }
        end
      end

      private def associated
        @associated ||= User.find(payload[:associated_id])
      end

      private def owner
        @owner ||= User.find(params[:user_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(owner)

        access_denied!
      end
    end
  end
end
