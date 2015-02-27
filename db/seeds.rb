# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'noreply@engines.onl', username: 'admin', password: 'EngOS2014', password_confirmation: 'EngOS2014')
Gallery.create(url: "http://enginegallery.engines.onl/json_published_softwares", name: "Engines Library")
