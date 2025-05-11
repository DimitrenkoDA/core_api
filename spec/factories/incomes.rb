FactoryBot.define do
  factory :income do
    amount { Money.from_amount(100, "EUR") }
    note { "Cashback" }
  end
end
