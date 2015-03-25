Fabricator(:video) do
  title { Faker::Lorem.characters(5) }
  description { Faker::Lorem.sentence }
end

Fabricator(:video_upload, from: :video) do
  large_cover { File.open("./spec/support/uploads/monk_large.jpg") }
  #large_cover { Rack::Test::UploadedFile.new("./spec/support/uploads/monk_large.jpg") }
end

