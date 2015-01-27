class ConsolidatedMigration < ActiveRecord::Migration
  def change

    create_table "attached_services", force: true do |t|
      t.integer "attached_services_handler_id"
    end

    create_table "attached_services_handlers", force: true do |t|
      t.integer "software_id"
    end

    create_table "attached_subservices", force: true do |t|
      t.integer "attached_service_id"
    end

    create_table "displays", force: true do |t|
      t.integer "software_id"
      t.string  "display_name"
      t.text    "display_description"
      t.string  "icon_file_name"
      t.string  "icon_content_type"
      t.integer "icon_file_size"
      t.string  "icon_updated_at"
    end

    create_table "domains", force: true do |t|
    end

    create_table "galleries", force: true do |t|
      t.string   "url"
      t.string   "name"
    end

    create_table "installs", force: true do |t|
      t.integer "software_id"
    end

    create_table "networks", force: true do |t|
      t.integer "software_id"
    end

    create_table "resources", force: true do |t|
      t.integer "software_id"
    end

    create_table "settings", force: true do |t|
      t.string   "default_domain"
      t.string   "default_site"
      t.string   "smtp_smarthost"
      t.string   "wallpaper_file_name"
      t.string   "wallpaper_content_type"
      t.integer  "wallpaper_file_size"
      t.datetime "wallpaper_updated_at"
      t.string   "background_color"
    end

    create_table "software_variables_handlers", force: true do |t|
      t.integer "software_id"
    end

    create_table "softwares", force: true do |t|
      t.string   "engine_name"
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

  end
end
