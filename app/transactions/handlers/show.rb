module Transactions
  module Handlers
    class Show < ApplicationHandler
      params do
        required(:transaction_id).filled(:integer)
      end

      def handle
        authorize!

        render status: 200 do
          json { Transactions::Presenters::Show.new(transaction).as_json(user: true) }
        end
      end

      private def transaction
        @transaction ||= Transaction.find(params[:transaction_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && transaction.owned_by?(current_session.owner)

        access_denied!
      end
    end
  end
end
