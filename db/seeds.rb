# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# = USERS

unless User.exists?(username: 'admin')
  FactoryGirl.create :user, username: 'admin', email: 'admin@example.com', password: 'fishsticks', admin: true
end

#== Cards

unless Card.any?
  e = FactoryGirl.create :expansion

  [:fool, :crisis, :bad_decision, :story].each do |card|
    30.times { FactoryGirl.create card, expansion: e }
  end
end
