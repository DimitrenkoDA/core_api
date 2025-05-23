module UserCategories
  module Handlers
    class Destroy < ApplicationHandler
      params do
        required(:user_category_id).filled(:integer)
      end

      def handle
        authorize!

        category.destroy!

        render status: 200 do
          json {}
        end
      end

      private def category
        @category ||= UserCategory.find(params[:user_category_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(category.user)

        access_denied!
      end
    end
  end
end
