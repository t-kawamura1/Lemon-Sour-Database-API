class LemonSour < ApplicationRecord
  mount_uploader :sour_image, SourImageUploader
  validates :name, presence: true

  scope :filtered_by, ->(search_params) {
    filterd_by_manufacturer(search_params[:manufacturer]).
      filterd_by_ingredient(search_params[:ingredient]).
      filterd_by_order(search_params[:order])
  }

  scope :filterd_by_manufacturer, ->(manufacturer_name) {
    if manufacturer_name == "すべて"
      return
    else
      where("manufacturer = ?", manufacturer_name)
    end
  }
  scope :filterd_by_ingredient, ->(ingredient_type) {
    case ingredient_type
    when "ー"
      where(zero_sugar: false, zero_sweetener: false)
    when "糖類ゼロ"
      where(zero_sugar: true)
    when "甘味料ゼロ"
      where(zero_sweetener: true)
    end
  }
  scope :filterd_by_order, ->(order_type) {
    case order_type
    when "新着順"
      order(updated_at: :desc)
    when "度数の高い順"
      order(alcohol_content: :desc)
    when "度数の低い順"
      order(alcohol_content: :asc)
    when "カロリーの高い順"
      order(calories: :desc)
    when "カロリーの低い順"
      order(calories: :asc)
    when "果汁の多い順"
      order(fruit_juice: :desc)
    when "果汁の少ない順"
      order(fruit_juice: :asc)
    end
  }
end
