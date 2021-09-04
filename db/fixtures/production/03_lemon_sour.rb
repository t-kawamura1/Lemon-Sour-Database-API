require "csv"

csv = CSV.read("db/fixtures/production/lemon_sour.csv")
csv.each do |lemon_sour|
  LemonSour.seed do |s|
    s.id = lemon_sour[0]
    s.name = lemon_sour[1]
    s.manufacturer = lemon_sour[2]
    s.calories = lemon_sour[3]
    s.alcohol_content = lemon_sour[4]
    s.pure_alcohol = lemon_sour[5]
    s.fruit_juice = lemon_sour[6]
    s.zero_sugar = lemon_sour[7]
    s.zero_sweetener = lemon_sour[8]
    s.sour_image = lemon_sour[9]
  end
end
