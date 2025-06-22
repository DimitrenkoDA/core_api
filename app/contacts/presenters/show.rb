module Contacts
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :contact

      def initialize(contact)
        @contact = contact
      end

      def as_json(options = {})
        {
          id: contact.id,
          owner_id: contact.owner_id,
          user: ::Users::Presenters::Show.new(contact.user).as_json,
          created_at: timestamp(contact.created_at),
          updated_at: timestamp(contact.updated_at)
        }
      end
    end
  end
end
