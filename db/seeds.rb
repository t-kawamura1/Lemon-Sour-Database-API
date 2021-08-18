5.times do |n|
  calories = Faker::Number.number(digits: 2)
  alcohol_content = Faker::Number.decimal(l_digits: 1)
  pure_alcohol = Faker::Number.decimal(l_digits: 2)
  fruit_juice = Faker::Number.decimal(l_digits: 2)
  LemonSour.create!(
    name: "キリン・ザ・ストロング 麒麟特性レモンサワー",
    manufacturer: "キリン",
    calories: calories,
    alcohol_content: alcohol_content,
    pure_alcohol: pure_alcohol,
    fruit_juice: fruit_juice,
    zero_sugar: true,
    zero_sweetener: true,
    sour_image: File.open("./public/development/ls_sample_kirin_tokusei.jpg"),
  )
  calories = Faker::Number.number(digits: 2)
  alcohol_content = Faker::Number.decimal(l_digits: 1)
  pure_alcohol = Faker::Number.decimal(l_digits: 2)
  fruit_juice = Faker::Number.decimal(l_digits: 2)
  LemonSour.create!(
    name: "こだわり酒場のレモンサワー 追い足しレモン",
    manufacturer: "サントリー",
    calories: calories,
    alcohol_content: alcohol_content,
    pure_alcohol: pure_alcohol,
    fruit_juice: fruit_juice,
    zero_sugar: false,
    zero_sweetener: true,
    sour_image: File.open("./public/development/ls_sample_suntory_kodawari_oitasi.jpg"),
  )
  calories = Faker::Number.number(digits: 2)
  alcohol_content = Faker::Number.decimal(l_digits: 1)
  pure_alcohol = Faker::Number.decimal(l_digits: 2)
  fruit_juice = Faker::Number.decimal(l_digits: 2)
  LemonSour.create!(
    name: "ザ・レモンクラフト 地中海レモン",
    manufacturer: "アサヒ",
    calories: calories,
    alcohol_content: alcohol_content,
    pure_alcohol: pure_alcohol,
    fruit_juice: fruit_juice,
    zero_sugar: true,
    zero_sweetener: false,
    sour_image: File.open("./public/development/ls_sample_asahi_craft_tityukai.jpg"),
  )
end

Administrator.create!(
  name: "レモンサワーの神",
  email: "admin@sample.com",
  password: "godoflemonsour",
)

3.times do |n|
  User.create!(
    name: "tk#{n+1}",
    email: "tk#{n+1}@sample.com",
    password: "password#{n+1}",
  )
end
