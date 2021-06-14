ActiveRecord::Schema.define(version: 2021_06_11_020804) do
  enable_extension "plpgsql"

  create_table "lemon_sours", force: :cascade do |t|
    t.string "name", null: false
    t.string "manufacturer"
    t.string "image"
    t.integer "calories"
    t.float "alcohol_content"
    t.float "pure_alcohol"
    t.float "fruit_juice"
    t.boolean "zero_sugar", default: false
    t.boolean "zero_sweetener", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
