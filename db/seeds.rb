10.times do |n|
  name = Faker::Beer.name
  manufacturer = Faker::Company.name
  calories = Faker::Number.number(digits: 2)
  alcohol_content = Faker::Number.decimal(l_digits: 1)
  pure_alcohol = Faker::Number.decimal(l_digits: 2)
  fruit_juice = Faker::Number.decimal(l_digits: 2)
  LemonSour.create!(
    name: name,
    manufacturer: manufacturer,
    calories: calories,
    alcohol_content: alcohol_content,
    pure_alcohol: pure_alcohol,
    fruit_juice: fruit_juice,
    zero_sugar: true,
    zero_sweetener: true,
    sour_image: File.open("./public/development/ls_sample.png"),
  )
end
