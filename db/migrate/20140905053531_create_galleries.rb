class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :url
    end
  end
end
