Fabricator(:user) do
  email_address { Faker::Internet.email }
  password { Faker::Internet.password(6) }
  full_name { Faker::Name.name } 
end