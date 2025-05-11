module Payments
  module Handlers
    class Show < ApplicationHandler
      params do
        required(:payment_id).filled(:integer)
      end

      def handle
        authorize!

        render status: 200 do
          json { Payments::Presenters::Show.new(payment).as_json(categories: true) }
        end
      end

      private def payment
        @payment ||= Payment.find(params[:payment_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(payment.user)

        access_denied!
      end
    end
  end
end
