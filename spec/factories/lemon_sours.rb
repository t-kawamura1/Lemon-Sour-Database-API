FactoryBot.define do
  factory :lemon_sour do
    name { "氷結 シチリア産レモン" }
    manufacturer { "キリン" }
    image { "MyString" }
    calories { 45}
    alcohol_content { 5 }
    pure_alcohol { 4 }
    fruit_juice { 2.7 }
    zero_sugar { false }
    zero_sweetener { false }
  end
end
