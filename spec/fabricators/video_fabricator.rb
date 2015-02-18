Fabricator(:video) do
  title { Faker::Lorem.characters(5) }
  description { Faker::Lorem.sentence }
end