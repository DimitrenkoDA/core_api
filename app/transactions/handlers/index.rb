module Transactions
  module Handlers
    class Index < ApplicationHandler
      params do
        required(:user_id).filled(:integer)

        optional(:polarity).filled(:string, included_in?: Transaction.polarities.keys)
        optional(:from).filled(:date_time)
        optional(:till).filled(:date_time)

        optional(:limit).filled(:integer, gteq?: 0, lteq?: ApplicationRecord::MAX_LIMIT)
        optional(:offset).filled(:integer, gteq?: 0)
      end

      def handle
        authorize!

        transactions = user.transactions
        transactions = transactions.where(polarity: params[:polarity]) if params.key?(:polarity)
        transactions = transactions.where("created_at >= ?", params[:from]) if params.key?(:from)
        transactions = transactions.where("created_at <= ?", params[:till]) if params.key?(:till)

        transactions = transactions.order(created_at: :desc).limit(limit).offset(offset)

        render status: 200 do
          json { Transactions::Presenters::Index.new(transactions).as_json(params: params) }
        end
      end

      private def user
        @user ||= User.find(params[:user_id])
      end

      private def authorize!
        authenticate!

        return if current_session.kind.user? && current_session.owned_by?(user)

        access_denied!
      end

      private def limit
        params[:limit] || ApplicationRecord::DEFAULT_LIMIT
      end

      private def offset
        params[:offset] || 0
      end
    end
  end
end
