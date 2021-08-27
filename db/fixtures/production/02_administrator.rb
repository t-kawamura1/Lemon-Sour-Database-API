Administrator.create!(
  id: 1,
  name: "レモンサワーの神",
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
)
