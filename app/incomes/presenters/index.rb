module Incomes
  module Presenters
    class Index < ApplicationPresenter
      attr_reader :incomes

      def initialize(incomes)
        @incomes = incomes
      end

      def as_json(options = {})
        {
          params: options.fetch(:params, {}),
          incomes: incomes.map do |income|
            Incomes::Presenters::Show.new(income).as_json(options)
          end
        }
      end
    end
  end
end
