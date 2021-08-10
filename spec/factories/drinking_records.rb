FactoryBot.define do
  factory :drinking_record do
    association :user
    association :lemon_sour
    drinking_date { "2021-08-03" }
    pure_alcohol_amount { 12.5 }
    drinking_amount { 500 }
  end
end
