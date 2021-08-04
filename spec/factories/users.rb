FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "test#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password(min_length: 8) }

    after(:create) do |user|
      create(:drinking_record, user: user, lemon_sour: create(:lemon_sour))
    end
  end
end
