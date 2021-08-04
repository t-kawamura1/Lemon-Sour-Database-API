FactoryBot.define do
  factory :drinking_record do
    user
    lemon_sour
    drinking_date { "2021-08-03" }
    pure_alcohol_amount { 26.5 }
    drinking_amount { 850 }
  end
end
