# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    status { Reservation.statuses.keys.sample }
    start_time { DateTime.now }
    covers { rand(1..10) }
    notes { Faker::Lorem.sentence }
    confirmation_request { false }
    confirmation_request_date { nil }
    trait :requested do
      status { 'requested' }
    end
    trait :pending do
      status { 'pending' }
    end
    trait :booked do
      status { 'booked' }
    end
    trait :ended do
      status { 'ended' }
    end
    trait :cancelled do
      status { 'cancelled' }
    end
    trait :noshow do
      status { 'noshow' }
    end
    trait :with_confirmation_request do
      confirmation_request { true }
      confirmation_request_date { Time.current }
    end
  end
end
