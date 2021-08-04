class DrinkingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :lemon_sour, optional: true

  validates :drinking_date, presence: true
  validates :pure_alcohol_amount, presence: true
  validates :drinking_amount, presence: true
end
