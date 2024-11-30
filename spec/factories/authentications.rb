FactoryBot.define do
  factory :authentication do
    step { :password }

    trait :expired do
      expires_at { Time.zone.now - 10.minutes }
    end

    trait :completed do
      completed_at { Time.zone.now - 10.minutes }
    end
  end
end
