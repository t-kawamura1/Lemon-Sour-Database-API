FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "test#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password(min_length: 8) }
  end
end
