FactoryBot.define do
  factory :payment do
    amount { Money.from_amount(100, "EUR") }
    note { "Sport supplements" }
  end
end
