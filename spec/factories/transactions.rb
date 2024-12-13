FactoryBot.define do
  factory :transaction do
    polarity { "debit" }
    amount { Money.from_amount(10.0, "EUR") }
  end
end
