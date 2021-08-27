3.times do |n|
  User.create!(
    name: "tk#{n + 1}",
    email: "tk#{n + 1}@sample.com",
    password: "password#{n + 1}",
  )
end
