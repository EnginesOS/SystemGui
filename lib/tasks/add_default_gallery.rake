namespace :db do
  desc "Add default library"
  task populate: :environment do
    library = GalleryInstall.create!( 
      url: "local",
      name: "development")
  end
end