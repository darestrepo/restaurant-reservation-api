# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    full_name { nil }
    
    trait :with_full_name_only do
      first_name { nil }
      last_name { nil }
      full_name { Faker::Name.name }
    end
  end
end
