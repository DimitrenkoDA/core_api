module UserCategories
  module Presenters
    class Index < ApplicationPresenter
      attr_reader :categories

      def initialize(categories)
        @categories = categories
      end

      def as_json(options = {})
        {
          params: options.fetch(:params, {}),
          categories: categories.map do |category|
            UserCategories::Presenters::Show.new(category).as_json(options)
          end
        }
      end
    end
  end
end
