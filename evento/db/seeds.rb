# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u1 = User.create name: "Antti", email: "antti@gmail.com"
u2 = User.create name: "Jaakko", email: "jaakko@outlook.com"
u3 = User.create name: "Seppo", email: "seppo@cs.helsinki.fi"

music = Category.create name:"Music"
sports = Category.create name:"Sports"
badminton =  Category.create name:"Sports", parent_id: sports.id

piano = Event.create title: "Piano with bros", description: "", category_id: music.id, creator_id: u2.id
sulis = Event.create title: "Sulis with bros", description: "", category_id: badminton.id, creator_id: u1.id
lenkki = Event.create title: "Lenkkeilyn alkeet", description: "Kumpulan ympäri", category_id: sports.id, creator_id: u3.id
