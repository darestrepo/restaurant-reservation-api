# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { Faker::Company.name }
    cuisines { Restaurant::CUISINES.sample(5).map { |c| c.to_s.titleize }.join(', ') }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    location { Faker::Address.city }
    send_confirmation { false }
    send_confirmation_before { 24 }
    confirmation_header_text { "Please confirm your reservation" }
    confirmation_body_text { "We're looking forward to seeing you. Please confirm your reservation by replying YES." }
    after :create do |restaurant|
      create(:opening_time, restaurant: restaurant)
    end
    
    trait :with_confirmation_enabled do
      send_confirmation { true }
      send_confirmation_before { 48 }
      confirmation_header_text { "Confirm your reservation at #{name}" }
      confirmation_body_text { "We're excited to welcome you to #{name}. Please confirm your reservation by replying YES." }
    end
    
    trait :with_channel_credentials do
      channel_phone_id { '241078215765353' }
      channel_token { 'sample_token' }
      channel_number { '+1234567890' }
    end
    
    trait :with_guest do
      after :create do |restaurant|
        create(:guest, restaurant: restaurant)
      end
    end
    
    trait :with_guest_and_reservation do
      after :create do |restaurant|
        guest = create(:guest, restaurant: restaurant)
        create(:reservation, restaurant: restaurant, guest: guest)
      end
    end
  end
end
