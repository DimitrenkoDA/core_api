module Authentications
  module Authenticators
    class Password
      def initialize(authentication)
        @authentication = authentication
      end

      def authenticate(data)
        return unless @authentication.owner.authenticate(data[:password])

        builder.complete(@authentication)
      end

      private def builder
        @builder ||= Authentications::Builder.new(@authentication.owner)
      end
    end
  end
end
