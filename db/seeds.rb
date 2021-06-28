5.times do |n|
  calories = Faker::Number.number(digits: 2)
  alcohol_content = Faker::Number.decimal(l_digits: 1)
  pure_alcohol = Faker::Number.decimal(l_digits: 2)
  fruit_juice = Faker::Number.decimal(l_digits: 2)
  LemonSour.create!(
    name: "キリン・ザ・ストロング　麒麟特性レモンサワー",
    manufacturer: "キリン",
    calories: calories,
    alcohol_content: alcohol_content,
    pure_alcohol: pure_alcohol,
    fruit_juice: fruit_juice,
    zero_sugar: true,
    zero_sweetener: true,
    sour_image: File.open("./public/development/ls_sample.png"),
  )
  LemonSour.create!(
    name: "こだわり酒場のレモンサワー　追い足しレモン",
    manufacturer: "サントリー",
    calories: calories,
    alcohol_content: alcohol_content,
    pure_alcohol: pure_alcohol,
    fruit_juice: fruit_juice,
    zero_sugar: true,
    zero_sweetener: true,
    sour_image: File.open("./public/development/ls_sample.png"),
  )
end
