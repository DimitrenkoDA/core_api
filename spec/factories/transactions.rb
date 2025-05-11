FactoryBot.define do
  factory :transaction do
    amount { Money.from_amount(10.0, "EUR") }
  end
end
