module Payments
  module Handlers
    class Search < ApplicationHandler
      params do
        required(:user_id).filled(:integer)
      end

      payload do
        optional(:from).filled(:date_time)
        optional(:till).filled(:date_time)

        optional(:amount).hash do
          optional(:currency).filled(:string)
          optional(:more).filled(:float)
          optional(:less).filled(:float)
        end

        optional(:category_ids).array(:integer)

        optional(:limit).filled(:integer, gteq?: 0, lteq?: ApplicationRecord::MAX_LIMIT)
        optional(:offset).filled(:integer, gteq?: 0)
      end

      def handle
        authorize!

        payments = user.payments

        payments = payments.where("created_at >= ?", payload[:from]) if payload.key?(:from)
        payments = payments.where("created_at < ?", payload[:till]) if payload.key?(:till)

        if payload.key?(:amount)
          if payload[:amount].key?(:currency)
            payments = payments.where(amount_currency: payload[:amount][:currency])

            if payload[:amount].key?(:more)
              more = Money.from_amount(payload[:amount][:more], payload[:amount][:currency]).cents

              payments = payments.where("amount_cents > ?", more)
            end

            if payload[:amount].key?(:less)
              less = Money.from_amount(payload[:amount][:less], payload[:amount][:currency]).cents

              payments = payments.where("amount_cents < ?", less)
            end
          end
        end

        if payload.key?(:category_ids)
          payments = payments.joins(:categories).where(user_categories: { id: payload[:category_ids] })
        end

        payments = payments.preload(:categories)
                           .order(created_at: :desc)
                           .limit(limit)
                           .offset(offset)

        render status: 200 do
          json { Payments::Presenters::Index.new(payments).as_json(params: payload, categories: true) }
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
        payload[:limit] || ApplicationRecord::DEFAULT_LIMIT
      end

      private def offset
        payload[:offset] || 0
      end
    end
  end
end
