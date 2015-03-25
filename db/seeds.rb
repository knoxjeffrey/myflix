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
            small_cover: open("public/tmp/monk.jpg"),
            large_cover: open("public/tmp/monk_large.jpg"),
            category_id: 2,
            video_url: "https://www.youtube.com/watch?v=RYDN5_pZZ9c&list=UUeNJ0zL2Mb-zNjZEm2KD0vg")
            
Video.create(title: "Family Guy",
            description: "Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family.",
            small_cover: open("public/tmp/family_guy.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=4072wpCuHv4&index=12&list=UUeNJ0zL2Mb-zNjZEm2KD0vg")
            
Video.create(title: "Futurama",
            description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future.",
            small_cover: open("public/tmp/futurama.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=QWfGinw6GUE&index=15&list=UUeNJ0zL2Mb-zNjZEm2KD0vg")
            
Video.create(title: "South Park",
            description: "Watch Cartman, Kenny, Stan and Kyle in all their foul-mouthed adventures!",
            small_cover: open("public/tmp/south_park.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=xdxORsHKaSc&list=UUeNJ0zL2Mb-zNjZEm2KD0vg&index=13")
            
Video.create(title: "Family Guy",
            description: "Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family.",
            small_cover: open("public/tmp/family_guy.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=RYDN5_pZZ9c&list=UUeNJ0zL2Mb-zNjZEm2KD0vg")

Video.create(title: "Futurama",
            description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future.",
            small_cover: open("public/tmp/futurama.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=4072wpCuHv4&index=12&list=UUeNJ0zL2Mb-zNjZEm2KD0vg")

Video.create(title: "South Park",
            description: "Watch Cartman, Kenny, Stan and Kyle in all their foul-mouthed adventures!",
            small_cover: open("public/tmp/south_park.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=QWfGinw6GUE&index=15&list=UUeNJ0zL2Mb-zNjZEm2KD0vg")
            
Video.create(title: "Futurama",
            description: "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future.",
            small_cover: open("public/tmp/futurama.jpg"),
            category_id: 1,
            video_url: "https://www.youtube.com/watch?v=xdxORsHKaSc&list=UUeNJ0zL2Mb-zNjZEm2KD0vg&index=13")

User.create(email_address: 'knoxjeffrey@outlook.com', password: 'password', full_name: "Jeff Knox")
User.create(email_address: 'knoxjeffrey@hotmail.com', password: 'password', full_name: "Hazel Knox")
User.create(email_address: 'info@tamars.co.uk', password: 'password', full_name: "Ruaridh Knox")

Review.create(user: User.find(1), video: Video.find(1), rating: 2, body: Faker::Lorem.paragraph)
Review.create(user: User.find(2), video: Video.find(1), rating: 5, body: Faker::Lorem.paragraph)
Review.create(user: User.find(1), video: Video.find(2), rating: 4, body: Faker::Lorem.paragraph)
Review.create(user: User.find(2), video: Video.find(3), rating: 3, body: Faker::Lorem.paragraph)
Review.create(user: User.find(2), video: Video.find(4), rating: 1, body: Faker::Lorem.paragraph)
Review.create(user: User.find(1), video: Video.find(4), rating: 5, body: Faker::Lorem.paragraph)

QueueItem.create(list_position: 1, user: User.find(1), video: Video.find(1))
QueueItem.create(list_position: 2, user: User.find(1), video: Video.find(2))
QueueItem.create(list_position: 1, user: User.find(2), video: Video.find(1))

Friendship.create(user: User.find(1), friend: User.find(2))
Friendship.create(user: User.find(1), friend: User.find(3))
Friendship.create(user: User.find(2), friend: User.find(1))