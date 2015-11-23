class AddDefaultsSetToApplicationDisplayProperties < ActiveRecord::Migration
  def up
    add_column :application_display_properties, :defaults_set, :boolean, default: false
    ApplicationDisplayProperties.all.each do |adp|
      adp.defaults_set = true
      adp.save
    end
  end

  def down
    remove_column :application_display_properties, :defaults_set
  end

end
