module System
  module Handlers
    class Alive < ApplicationHandler
      def handle
        render status: 200 do
          json { System::Alive.new }
        end
      end
    end
  end
end
