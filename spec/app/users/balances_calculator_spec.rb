require "rails_helper"

RSpec.describe Users::BalanceCalculator do
  let!(:user) { create(:user, email: "someone@mail.com") }

  let!(:transaction_a) { create(:transaction, user: user, amount: Money.from_amount(5, "EUR")) }
  let!(:transaction_b) { create(:transaction, user: user, amount: Money.from_amount(70, "EUR")) }
  let!(:transaction_c) { create(:transaction, user: user, amount: Money.from_amount(20, "RUB")) }
  let!(:transaction_d) { create(:transaction, user: user, amount: Money.from_amount(60, "RSD")) }
  let!(:transaction_e) { create(:transaction, user: user, amount: Money.from_amount(1300, "RSD")) }
  let!(:transaction_f) { create(:transaction, user: user, amount: Money.from_amount(-35, "EUR")) }
  let!(:transaction_6) { create(:transaction, user: user, amount: Money.from_amount(-2000, "RSD")) }

  describe "#calculate" do
    subject { described_class.new(user).calculate }

    it "calculates balances properly" do
      subject

      balances = user.reload.balances
      expect(balances.keys).to contain_exactly("EUR", "RUB", "RSD")
      expect(balances["EUR"]).to eq(Money.from_amount(40, "EUR").to_f)
      expect(balances["RUB"]).to eq(Money.from_amount(20, "RUB").to_f)
      expect(balances["RSD"]).to eq(Money.from_amount(-640, "RSD").to_f)
    end
  end
end
