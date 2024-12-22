module UserCategories
  module Handlers
    class Show < ApplicationHandler
      params do
        required(:user_category_id).filled(:integer)
      end

      def handle
        authorize!

        render status: 200 do
          json { UserCategories::Presenters::Show.new(category).as_json(user: true) }
        end
      end

      private def category
        @category ||= UserCategory.find(params[:user_category_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && category.owned_by?(current_session.owner)

        access_denied!
      end
    end
  end
end
