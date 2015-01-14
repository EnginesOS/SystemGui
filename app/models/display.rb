class Display < ActiveRecord::Base

  attr_accessor :delete_icon

  has_attached_file :icon, dependent: :destroy

  belongs_to :software
  
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }
  validates :display_name, length: { maximum: 30 }
  validates :display_description, length: { maximum: 1000 }

  def self.engine_display_properties_from_api engine_name
    engines_software_details = EnginesSoftware.blueprint_software_details(engine_name)
    {
      display_name: engines_software_details['name'],
      display_description: engines_software_details['description']
    }
  end

  def self.engine_icon_url_from_api engine_name
p :engine_name
p engine_name    
    engines_software_details = EnginesSoftware.blueprint_software_details(engine_name)
p :engines_software_details
p engines_software_details

    engines_software_details['icon_url']
  end

end