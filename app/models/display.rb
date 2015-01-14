class Display < ActiveRecord::Base

  attr_accessor :delete_icon

  has_attached_file :icon, dependent: :destroy

  belongs_to :software
  
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }
  validates :display_name, length: { maximum: 30 }
  validates :display_description, length: { maximum: 1000 }

  def load_display_property_defaults
    engines_software_details = EnginesSoftware.blueprint_software_details(software.engine_name)

p :engines_software_detailsqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
p engines_software_details

    self.display_name = engines_software_details['name']
    self.display_description = engines_software_details['description']
    # self.terms_and_conditions_accepted = "1"

    self
  end

end