module Users
  class BalanceCalculator
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def calculate
      balances = user.transactions.group_by { |trx| trx.amount_currency }
      balances = balances.transform_values { |items| items.sum(&:amount).to_f }

      user.update!(balances: balances)
    end
  end
end
