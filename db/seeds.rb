# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all

User.create(email: 'user_one@example.com',
            zip: '80218',
            username:'areid.sj',
            flat_id: '5ecda42869109757b671ceaa',
            about: 'I like music',
            interests: 'Music',
            instruments: 'Guitar')
