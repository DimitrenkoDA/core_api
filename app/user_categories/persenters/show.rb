module UserCategories
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :category

      def initialize(category)
        @category = category
      end

      def as_json(options = {})
        json = {
          id: category.id,
          kind: category.kind,
          name: category.name,
          colour_code: category.colour_code,
          created_at: timestamp(category.created_at),
          updated_at: timestamp(category.updated_at),
        }

        json[:description] if category.description.present?

        json
      end
    end
  end
end
