10.times do |i|
  name = Faker::Name.first_name
  email = Faker::Internet.email
  password = 'password'
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    admin: false;
  )
end

names = [*'A'..'E']
names.each do |name|
  Label.create!(
    name: name,
    user_id: nil
  )
end

100.times do |i|
  Task.create!(
    name: "task#{i + 1}",
    detail: "task detail#{i + 1}",
    deadline: DateTime.now + 10,
    status: rand(3),
    priority: rand(3),
    user_id: rand(12),
  )
end

100.times do |i|
  Labeling.create!(
    task_id: rand(101),
    label_id: rand(6)
  )
end
