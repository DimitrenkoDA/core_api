module Contacts
  module Handlers
    class Show < ApplicationHandler
      params do
        required(:contact_id).filled(:integer)
      end

      def handle
        authorize!

        render status: 200 do
          json { Contacts::Presenters::Show.new(contact).as_json }
        end
      end

      private def contact
        @contact ||= Contact.find(params[:contact_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(contact.owner)

        access_denied!
      end
    end
  end
end
