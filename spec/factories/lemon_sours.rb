FactoryBot.define do
  factory :lemon_sour do
    name { "氷結 シチリア産レモン" }
    manufacturer { "キリン" }
    sour_image { "MyImage" }
    calories { 45 }
    alcohol_content { 5 }
    pure_alcohol { 4 }
    fruit_juice { 2.7 }
    zero_sugar { false }
    zero_sweetener { false }

    trait :zero_sugar_sour do
      name { "ストロングゼロ" }
      manufacturer { "サントリー" }
      sour_image { "MyImage" }
      calories { 54 }
      alcohol_content { 9 }
      pure_alcohol { 7.2 }
      fruit_juice { 3 }
      zero_sugar { true }
    end

    trait :zero_sweetener_sour do
      name { "贅沢絞り" }
      manufacturer { "アサヒ" }
      sour_image { "MyImage" }
      calories { 39 }
      alcohol_content { 4 }
      pure_alcohol { 3.2 }
      fruit_juice { 14 }
      zero_sweetener { true }
    end
  end
end
