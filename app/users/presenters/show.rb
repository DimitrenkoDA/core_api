module Users
  module Presenters
    class Show < ApplicationPresenter
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def as_json(options = {})
        json = {
          id: user.id,
          email: user.email,
          created_at: timestamp(user.created_at),
          updated_at: timestamp(user.updated_at),
        }

        if options.fetch(:balances, false) && user.balances.present?
          json[:balances] = user.balances
        end

        json[:first_name] = user.first_name if user.first_name.present?
        json[:last_name] = user.last_name if user.last_name.present?
        json[:birth_date] = user.birth_date.strftime("%d.%m.%Y") if user.birth_date.present?

        json
      end
    end
  end
end
