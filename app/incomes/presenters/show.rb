module Incomes
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :income

      def initialize(income)
        @income = income
      end

      def as_json(options = {})
        json = {
          id: income.id,
          user_id: income.user_id,
          amount: money(income.amount),
          created_at: timestamp(income.created_at),
          updated_at: timestamp(income.updated_at),
        }

        if income.note.present?
          json[:note] = income.note
        end

        if income.categories.present? && options.fetch(:categories, false)
          json[:categories] = income.categories.map do |category|
            ::UserCategories::Presenters::Show.new(category).as_json
          end
        end

        json
      end
    end
  end
end
