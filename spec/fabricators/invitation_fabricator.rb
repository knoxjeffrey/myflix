Fabricator(:invitation) do
  recipient_name { Faker::Name.name }
  recipient_email_address { Faker::Internet.email }
  message { Faker::Lorem.paragraph } 
end