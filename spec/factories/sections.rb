FactoryBot.define do
  factory :section do
    restaurant { nil }
    name { "MyString" }
    description { "MyText" }
    capacity { 1 }
    metadata { "" }
  end
end
