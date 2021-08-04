class CreateDrinkingRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :drinking_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lemon_sour, foreign_key: true
      t.date :drinking_date, null: false
      t.float :pure_alcohol_amount, null: false
      t.integer :drinking_amount, null: false

      t.timestamps
    end
  end
end
