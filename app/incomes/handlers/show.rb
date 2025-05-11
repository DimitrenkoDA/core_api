module Incomes
  module Handlers
    class Show < ApplicationHandler
      params do
        required(:income_id).filled(:integer)
      end

      def handle
        authorize!

        render status: 200 do
          json { Incomes::Presenters::Show.new(income).as_json(categories: true) }
        end
      end

      private def income
        @income ||= Income.find(params[:income_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(income.user)

        access_denied!
      end
    end
  end
end
