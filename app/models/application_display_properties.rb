class ApplicationDisplayProperties < ActiveRecord::Base

  include Rails.application.routes.url_helpers
  require 'open_uri_redirections'

  attr_accessor :set_icon

  has_attached_file :icon, dependent: :destroy,
      styles: {
        small: "64x64>",
        medium: "128x128>",
        large: "256x256>" }
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/

  belongs_to :application

  validates :title, length: { maximum: 30 }
  validates :detail, length: { maximum: 1000 }

  def application_name
    application.container_name
  end

  def icon_url(size=nil)
    icon.exists? ? icon.url(size) : ""
  end

  def set_defaults
    title_from_blueprint = application.blueprint_software_details[:short_title]
    self.title = title_from_blueprint.present? ? title_from_blueprint : application.container_name
    self.detail = application.blueprint_software_details[:long_title]
    self.defaults_set = true
    self.save
    url_for_new_icon = installer_icon_url.present? ? installer_icon_url : icon_url_from_blueprint
    self.icon = file_from(url_for_new_icon)
    self.save
  end

  def update(params)
    if params[:set_icon] == "Keep existing icon"
      params.delete(:icon)
      self.assign_attributes(params)
    elsif params[:set_icon] == "No icon"
      params.delete(:icon)
      self.assign_attributes(params)
      icon.clear
    elsif params[:set_icon] == "Blueprint icon"
      params.delete(:icon)
      self.assign_attributes(params)
      load_icon_from_blueprint_icon_url
    elsif params[:set_icon] == "Installer icon"
      params.delete(:icon)
      self.assign_attributes(params)
      load_icon_from_installer_icon_url
    elsif params[:set_icon] == "Upload icon"
      self.assign_attributes(params)
    end
    (valid? && save)
  end

  def load_icon_from_blueprint_icon_url
    self.icon = file_from icon_url_from_blueprint
  end

  def load_icon_from_installer_icon_url
    self.icon = file_from installer_icon_url
  end

  def icon_url_from_blueprint
    application.blueprint_software_details[:icon_url]
  end

private

  def default_icon_url
    @icon_url ||= icon_url_from_blueprint
  end

  def file_from icon_url
    return nil if icon_url.blank?
    extname = File.extname(icon_url)
    basename = File.basename(icon_url, extname)
    file = Tempfile.new([basename, extname])
    file.binmode
    open(URI.parse(icon_url), :allow_redirections => :safe) do |data|
      file.write data.read
    end
    file.rewind
    return file
  rescue => e
    p :failed_to_load_icon
    p e.message
    p e.backtrace
    return nil
  end

end
