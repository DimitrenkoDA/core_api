module System
  module Presenters
    class Owner < ApplicationPresenter
      attr_reader :owner

      def initialize(owner)
        @owner = owner
      end

      def as_json(options = nil)
        type = owner.class.name

        {
          type: type,
          data: {
            id: owner.id,
            email: owner.email
          }
        }
      end
    end
  end
end
