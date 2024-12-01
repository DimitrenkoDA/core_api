module Users
  module Presenters
    class Index < ApplicationPresenter
      attr_reader :users

      def initialize(users)
        @users = users
      end

      def as_json(options = {})
        {
          params: options.fetch(:params, {}),
          users: users.map { |user| Users::Presenters::Show.new(user).as_json(options) }
        }
      end
    end
  end
end
