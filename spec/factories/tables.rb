FactoryBot.define do
  factory :table do
    restaurant { nil }
    name { "MyString" }
    section { "MyString" }
    capacity { 1 }
    position_x { 1 }
    position_y { 1 }
    metadata { "" }
  end
end
