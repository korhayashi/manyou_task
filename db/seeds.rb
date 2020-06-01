# name = Faker::Name.first_name
# email = Faker::Internet.email
# password = 'password'
# User.create!(
#   name: name,
#   email: email,
#   password: password,
#   password_confirmation: password
# )

names = [*'A'..'E']
names.each do |name|
  Label.create!(
    name: name
  )
end
