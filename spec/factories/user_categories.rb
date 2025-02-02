FactoryBot.define do
  factory :user_category do
    kind { "payment" }
    name { Faker::Lorem.word }
    colour_code { Faker::Color.hex_color }
    description { Faker::Lorem.sentence }
  end
end
