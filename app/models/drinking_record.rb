class DrinkingRecord < ApplicationRecord
  belongs_to :user
  belongs_to :lemon_sour, optional: true

  validates :drinking_date, presence: true
  validates :pure_alcohol_amount, presence: true
  validates :drinking_amount, presence: true

  scope :total_pure_alcohol_by_date, -> {
    group(:drinking_date).
      select("drinking_date, SUM(pure_alcohol_amount) AS total_pure_alcohol, SUM(drinking_amount) AS total_drinking")
  }

  scope :pure_alcohol_amount_specified, ->(amount) {
    total_pure_alcohol_by_date.
      having("SUM(pure_alcohol_amount) = ?", amount)
  }

  scope :pure_alcohol_amount_greater_than_and_less_than, ->(min_amount, max_amount) {
    total_pure_alcohol_by_date.
      having("? < SUM(pure_alcohol_amount)", min_amount).
      having("SUM(pure_alcohol_amount) < ?", max_amount)
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

  scope :count_sour_name, ->(max_count) {
    left_outer_joins(:lemon_sour).
      where("name != ?", "").
      group(:name).
      select("name, COUNT(name) AS name_count").
      order(count: :desc).
      limit(max_count)
  }

  scope :sum_amouts_by_year_month, -> {
    select("to_char(drinking_date, 'YYYY-MM') AS year_month, SUM(pure_alcohol_amount)  total_pure_alcohol, SUM(drinking_amount) AS total_drinking").
      group("year_month")
  }
end
