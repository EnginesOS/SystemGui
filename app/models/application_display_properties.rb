class ApplicationDisplayProperties < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  attr_accessor :delete_icon, :reset_icon
  has_attached_file :icon, dependent: :destroy
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  before_validation { icon.clear if delete_icon == '1' }

  belongs_to :application

  validates :title, length: { maximum: 30 }
  validates :detail, length: { maximum: 1000 }

  def application_name
    application.container_name
  end

  def icon_url
    icon.exists? ? icon.url : url_for("placeholder_for_missing_icon.jpg")
  end

  def set_defaults
    self.title = application.blueprint_software_details["short_title"]
    self.detail = application.blueprint_software_details["description"]
    self.icon = file_from_default_icon_url
    self
  end

  def update(params)
    result = super params
    if reset_icon == "1"
      reset_icon_to_default
    end
    result 
  end

  def reset_icon_to_default
    self.icon = file_from_default_icon_url
    self.reset_icon = false
    self.save
    self
  end

  def icon_url_from_blueprint
    application.blueprint_software_details["icon_url"]
  end

private

  def default_icon_url
    @icon_url ||= icon_url_from_blueprint
  end

  def file_from_default_icon_url
    return nil if default_icon_url.blank?
    extname = File.extname(default_icon_url)
    basename = File.basename(default_icon_url, extname)
    file = Tempfile.new([basename, extname])
    file.binmode
    open(URI.parse(default_icon_url)) do |data|  
      file.write data.read
    end
    file.rewind
    return file
  rescue
    return nil
  end  

end