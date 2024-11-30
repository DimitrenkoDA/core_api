module System
  module Handlers
    class Me < ApplicationHandler
      def handle
        authenticate!

        render status: 200 do
          json { System::Presenters::Session.new(current_session) }
        end
      end
    end
  end
end
