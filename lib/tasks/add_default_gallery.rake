namespace :db do
  desc "Add default library"
  task populate: :environment do
    GalleryInstall.create!( 
      url: "http://enginegallery.engines.onl/json_published_softwares",
      name: "Engines Library"
    )
  end
end