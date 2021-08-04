FactoryBot.define do
  factory :drinking_record do
    user { nil }
    lemon_sour { nil }
    drinking_date { "2021-08-03" }
    pure_alcohol_amount { 1.5 }
    drinking_amount { 1 }
  end
end
