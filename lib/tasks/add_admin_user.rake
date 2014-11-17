namespace :db do
  desc "Add admin user"
  task populate: :environment do
    admin = User.create!(#FIXME this is to be dynamic 
                email: "admin@engines.onl",
                username: "admin",
                 password: "EngOS2014",
                 password_confirmation: "EngOS2014")   
  end
end