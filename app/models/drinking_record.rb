class DrinkingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :lemon_sour, optional: true

  validates :drinking_date, presence: true
  validates :pure_alcohol_amount, presence: true
  validates :drinking_amount, presence: true

  scope :total_pure_alcohol_by_date, -> {
    group(:drinking_date).
      select("drinking_date, SUM(pure_alcohol_amount) as total_pure_alcohol, SUM(drinking_amount) as total_drinking").
      order(drinking_date: :asc)
  }

  scope :pure_alcohol_amount_less_than, ->(amount) {
    total_pure_alcohol_by_date.
      having("SUM(pure_alcohol_amount) < ?", amount)
  }

  scope :pure_alcohol_amount_between, ->(min_amount, max_amount) {
    total_pure_alcohol_by_date.
      having("? <= SUM(pure_alcohol_amount)", min_amount).
      having("SUM(pure_alcohol_amount) < ?", max_amount)
  }

  scope :pure_alcohol_amount_or_more, ->(amount) {
    total_pure_alcohol_by_date.
      having("? <= SUM(pure_alcohol_amount)", amount)
  }

  scope :dates_and_sour_name, -> {
    left_outer_joins(:lemon_sour).
      select("drinking_date, name").
      order(drinking_date: :asc)
  }

  scope :sum_amouts_by_year_month, -> {
    select("to_char(drinking_date, 'YYYY-MM') as year_month, SUM(pure_alcohol_amount)  total_pure_alcohol, SUM(drinking_amount) as total_drinking").
      group("year_month")
  }
end
