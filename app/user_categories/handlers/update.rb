module UserCategories
  module Handlers
    class Update < ApplicationHandler
      params do
        required(:user_category_id).filled(:integer)
      end

      payload do
        optional(:name).filled(:string)
        optional(:kind).filled(:string, included_in?: UserCategory.kinds.keys)
        optional(:colour_code).filled(:string, format?: /\A#[0-9a-fA-F]+\z/)

        optional(:description).maybe(:string)
      end

      def handle
        authorize!

        category.name = payload[:name] if payload.key?(:name)
        category.kind = payload[:kind] if payload.key?(:kind)
        category.colour_code = payload[:colour_code] if payload.key?(:colour_code)
        category.description = payload[:description] if payload.key?(:description)
        category.save!

        render status: 200 do
          json { UserCategories::Presenters::Show.new(category).as_json(user: true) }
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
