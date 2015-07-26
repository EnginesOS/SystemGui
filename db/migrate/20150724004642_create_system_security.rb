class CreateSystemSecurity < ActiveRecord::Migration
  def change
    create_table :system_security_certificates do |t|
      t.string   "certificate_file_name"
      t.string   "certificate_content_type"
      t.integer  "certificate_file_size"
      t.datetime "certificate_updated_at"
    end
    create_table :system_security_keys do |t|
      t.string   "public_key_file_name"
      t.string   "public_key_content_type"
      t.integer  "public_key_file_size"
      t.datetime "public_key_updated_at"
    end
  end
end
