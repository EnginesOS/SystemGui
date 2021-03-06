# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160312022024) do

  create_table "application_actions", force: :cascade do |t|
  end

  create_table "application_display_properties", force: :cascade do |t|
    t.integer "application_id"
    t.string  "title"
    t.text    "detail"
    t.string  "icon_file_name"
    t.string  "icon_content_type"
    t.integer "icon_file_size"
    t.string  "icon_updated_at"
    t.string  "installer_icon_url"
    t.boolean "defaults_set",       default: false
  end

  create_table "application_network_properties", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "application_resources_properties", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "application_service_connection_subservice_connector_configurations", force: :cascade do |t|
  end

  create_table "application_service_connector_configurations", force: :cascade do |t|
    t.integer "application_service_connector_id"
  end

  create_table "application_service_connector_types", force: :cascade do |t|
    t.integer "application_service_connector_id"
  end

  create_table "application_service_connectors", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "application_service_data_imports", force: :cascade do |t|
  end

  create_table "application_services", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "application_services_properties", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "application_subservices", force: :cascade do |t|
    t.integer "application_service_id"
  end

  create_table "application_variables_properties", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "applications", force: :cascade do |t|
    t.string  "container_name"
    t.integer "application_installation_id"
    t.integer "docker_hub_installation_id"
  end

  create_table "display_settings", force: :cascade do |t|
    t.string   "wallpaper_file_name"
    t.string   "wallpaper_content_type"
    t.integer  "wallpaper_file_size"
    t.datetime "wallpaper_updated_at"
    t.string   "background_color"
    t.string   "icon_text_color"
    t.string   "system_label"
    t.text     "desktop_header"
    t.text     "desktop_footer"
    t.string   "system_title"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean  "show_desktop_signin"
    t.boolean  "center_align"
    t.string   "icon_size"
  end

  create_table "domain_certificates", force: :cascade do |t|
    t.string  "certificate"
    t.string  "certificate_file_file_name"
    t.string  "certificate_file_content_type"
    t.integer "certificate_file_file_size"
    t.string  "certificate_file_updated_at"
  end

  create_table "domain_settings", force: :cascade do |t|
  end

  create_table "domains", force: :cascade do |t|
  end

  create_table "eports", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "install_from_blueprints", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "install_from_docker_hubs", force: :cascade do |t|
    t.integer "application_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "url"
    t.string "name"
  end

  create_table "library_settings", force: :cascade do |t|
    t.integer "default_library_id"
  end

  create_table "service_actions", force: :cascade do |t|
  end

  create_table "service_configurations", force: :cascade do |t|
  end

  create_table "services", force: :cascade do |t|
    t.string "container_name"
  end

  create_table "system_data_caches", force: :cascade do |t|
    t.boolean "failed_build_flag"
    t.text    "memory_statistics"
    t.text    "system_update_status"
  end

  create_table "system_security_certificates", force: :cascade do |t|
    t.string   "certificate_file_name"
    t.string   "certificate_content_type"
    t.integer  "certificate_file_size"
    t.datetime "certificate_updated_at"
  end

  create_table "system_security_keys", force: :cascade do |t|
    t.string   "public_key_file_name"
    t.string   "public_key_content_type"
    t.integer  "public_key_file_size"
    t.datetime "public_key_updated_at"
  end

  create_table "users", force: :cascade do |t|
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

  create_table "variables", force: :cascade do |t|
    t.integer "variable_consumer_id"
    t.string  "variable_consumer_type"
  end

end
