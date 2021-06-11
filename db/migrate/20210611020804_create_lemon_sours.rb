class CreateLemonSours < ActiveRecord::Migration[6.0]
  def change
    create_table :lemon_sours do |t|
      t.string :name, null: false
      t.string :manufacturer
      t.string :image
      t.integer :calories
      t.float :alcohol_content
      t.float :pure_alcohol
      t.float :fruit_juice
      t.boolean :zero_sugar, default: false
      t.boolean :zero_sweetener, default: false

      t.timestamps
    end
  end
end
