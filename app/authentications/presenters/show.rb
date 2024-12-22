module Authentications
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :authentication

      def initialize(authentication)
        @authentication = authentication
      end

      def as_json(options = nil)
        json = {
          id: authentication.id,
          step: authentication.step,
          expires_at: authentication.expires_at,
          expiration_period: 1.year
        }

        if authentication.prev_authentication.present?
          json[:prev_authentication] = Authentications::Presenters::Show.new(authentication.prev_authentication).as_json
        end

        if authentication.complete?
          json[:session] = System::Presenters::Session.new(System::Session.build(authentication.owner))
        end

        json
      end
    end
  end
end
