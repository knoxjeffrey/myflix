# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "TV Comedies")
Category.create(name: "TV Dramas")

Video.create(title: "Monk",
            description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.",
            small_cover_url: "/tmp/monk.jpg",
            large_cover_url: "/tmp/monk_large.jpg",
            category_id: 2)
            
Video.create(title: "Family Guy",
            description: "Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family.",
            small_cover_url: "/tmp/family_guy.jpg",
            category_id: 1)
            
Video.create(title: "Futurama",
            description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future.",
            small_cover_url: "/tmp/futurama.jpg",
            category_id: 1)
            
Video.create(title: "South Park",
            description: "Watch Cartman, Kenny, Stan and Kyle in all their foul-mouthed adventures!",
            small_cover_url: "/tmp/south_park.jpg",
            category_id: 1)
            
Video.create(title: "Family Guy",
            description: "Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family.",
            small_cover_url: "/tmp/family_guy.jpg",
            category_id: 1)

Video.create(title: "Futurama",
            description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future.",
            small_cover_url: "/tmp/futurama.jpg",
            category_id: 1)

Video.create(title: "South Park",
            description: "Watch Cartman, Kenny, Stan and Kyle in all their foul-mouthed adventures!",
            small_cover_url: "/tmp/south_park.jpg",
            category_id: 1)
            
Video.create(title: "Futurama",
            description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future.",
            small_cover_url: "/tmp/futurama.jpg",
            category_id: 1)

User.create(email_address: 'knoxjeffrey@outlook.com', password: 'password', full_name: "Jeff Knox")
User.create(email_address: 'knoxjeffrey@hotmail.com', password: 'password', full_name: "Hazel Knox")

Review.create(user: User.find(1), video: Video.find(1), rating: 2, body: Faker::Lorem.paragraph)
Review.create(user: User.find(2), video: Video.find(1), rating: 5, body: Faker::Lorem.paragraph)
Review.create(user: User.find(1), video: Video.find(2), rating: 4, body: Faker::Lorem.paragraph)
Review.create(user: User.find(2), video: Video.find(3), rating: 3, body: Faker::Lorem.paragraph)
Review.create(user: User.find(2), video: Video.find(4), rating: 1, body: Faker::Lorem.paragraph)
Review.create(user: User.find(1), video: Video.find(4), rating: 5, body: Faker::Lorem.paragraph)

QueueItem.create(list_position: 1, user: User.find(1), video: Video.find(1))
QueueItem.create(list_position: 2, user: User.find(1), video: Video.find(2))