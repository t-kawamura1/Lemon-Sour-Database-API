class AddSourImageToLemonSours < ActiveRecord::Migration[6.0]
  def change
    add_column :lemon_sours, :sour_image, :string
  end
end
