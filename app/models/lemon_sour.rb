class LemonSour < ApplicationRecord
  mount_uploader :sour_image, SourImageUploader
  validates :name, presence: true

  scope :displayed_based_on, ->(search_params) {
    for_manufacturer(search_params[:manufacturer]).
      for_ingredient(search_params[:ingredient]).
      for_order(search_params[:order])
  }

  scope :for_manufacturer, ->(manufacturer_name) {
    if manufacturer_name == ""
      return
    elsif manufacturer_name == "すべて"
      return
    else
      where("manufacturer = ?", manufacturer_name)
    end
  }
  scope :for_ingredient, ->(ingredient_type) {
    case ingredient_type
    when ""
      return
    when "すべて"
      return
    when "糖類ゼロ"
      where(zero_sugar: true)
    when "甘味料ゼロ"
      where(zero_sweetener: true)
    end
  }
  scope :for_order, ->(order_type) {
    case order_type
    when ""
      order(updated_at: :desc)
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
