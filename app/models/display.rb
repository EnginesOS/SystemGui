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
    if engines_software_details.kind_of?(EnginesOSapiResult)
      {}
    else
      display_name = (engines_software_details['short_title'] || engines_software_details['full_title'] || engines_software_details['name'])[0,29]
      display_description = engines_software_details['description'][0,999]
      {
        display_name: display_name,
        display_description: display_description
      }
    end  
  end

  def self.engine_icon_url_from_api engine_name
    EnginesSoftware.blueprint_software_details(engine_name)['icon_url']
  end

end