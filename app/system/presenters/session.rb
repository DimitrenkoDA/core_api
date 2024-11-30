module System
  module Presenters
    class Session < ApplicationPresenter
      def initialize(session)
        @session = session
      end

      def as_json(options = nil)
        {
          uuid: @session.uuid,
          kind: @session.kind,
          token: @session.token,
          owner: System::Presenters::Owner.new(@session.owner).as_json
        }
      end
    end
  end
end
