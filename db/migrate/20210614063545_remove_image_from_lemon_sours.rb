class RemoveImageFromLemonSours < ActiveRecord::Migration[6.0]
  def change
    remove_column :lemon_sours, :image, :string
  end
end
