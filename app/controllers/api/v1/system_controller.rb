module API
  module V1
    class SystemController < ApplicationController
      def alive
        handler = ::System::Handlers::Alive.new(self)
        handler.handle!
      end

      def me
        handler = ::System::Handlers::Me.new(self)
        handler.handle!
      end
    end
  end
end
