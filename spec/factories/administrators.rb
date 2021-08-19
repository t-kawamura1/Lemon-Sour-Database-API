FactoryBot.define do
  factory :administrator do
    name { Faker::Name.name }
    sequence(:email) { |n| "test_admin#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password(min_length: 8) }
  end
end
