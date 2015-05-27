class ConsolidatedMigration < ActiveRecord::Migration
  def change

    create_table "application_services", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "application_subservices", force: true do |t|
      t.integer "application_service_id"
    end
  
    create_table "applications", force: true do |t|
      t.string "container_name"
      t.integer "application_installation_id"
      t.integer "docker_hub_installation_id"
    end
  
    create_table "application_installations", force: true do |t|
      t.integer "application_id"
    end

    create_table "application_installs", force: true do |t|
      t.integer "application_id"
    end

    # create_table "application_uninstalls", force: true do |t|
      # t.integer "application_id"
    # end

    create_table "backup_tasks", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "backup_properties", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "display_properties", force: true do |t|
      t.integer "application_id"
      t.string  "title"
      t.text    "detail"
      t.string  "icon_file_name"
      t.string  "icon_content_type"
      t.integer "icon_file_size"
      t.string  "icon_updated_at"
    end
  
    create_table "docker_hub_installations", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "domains", force: true do |t|
    end
    
    create_table "domain_certificates", force: true do |t|
      t.string  "certificate"
      t.string  "certificate_file_file_name"
      t.string  "certificate_file_content_type"
      t.integer "certificate_file_file_size"
      t.string  "certificate_file_updated_at"
    end
    
    create_table "eports", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "galleries", force: true do |t|
      t.string "url"
      t.string "name"
    end
  
    create_table "gallery_settings", force: true do |t|
      t.integer "default_gallery_id"
    end
    
    create_table "installers", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "network_properties", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "resources_properties", force: true do |t|
      t.integer "application_id"
    end
  
    create_table "services", force: true do |t|
      t.string "container_name"
    end
  
    create_table "services_properties", force: true do |t|
      t.integer "application_id"
    end
    
    create_table "service_configurations", force: true do |t|
    end
  
    create_table "desktop_settings", force: true do |t|
      t.string   "wallpaper_file_name"
      t.string   "wallpaper_content_type"
      t.integer  "wallpaper_file_size"
      t.datetime "wallpaper_updated_at"
      t.string   "background_color"
      t.string   "icon_text_color"
    end
  
    create_table "domain_settings", force: true do |t|
    end
  
    create_table "installer_settings", force: true do |t|
      t.boolean  "install_from_docker_hub"
    end
  
    create_table "users", force: true do |t|
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "username"
      t.string   "user_type"
    end
  
    add_index "users", ["email"], name: "index_users_on_email", unique: true
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    add_index "users", ["username"], name: "index_users_on_username", unique: true
  
    create_table "variables", force: true do |t|
      t.integer "variable_consumer_id"
      t.string  "variable_consumer_type"
    end
  
    create_table "variables_properties", force: true do |t|
      t.integer "application_id"
    end

  end
end
