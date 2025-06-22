module Contacts
  module Presenters
    class Index < ApplicationPresenter
      attr_reader :contacts

      def initialize(contacts)
        @contacts = contacts
      end

      def as_json(options = {})
        {
          params: options.fetch(:params, {}),
          contacts: contacts.map do |contact|
            Contacts::Presenters::Show.new(contact).as_json(options)
          end
        }
      end
    end
  end
end
