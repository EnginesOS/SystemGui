class SystemSecurityKey < ActiveRecord::Base

  include Engines::Api

  has_attached_file :public_key
  validates_attachment_presence :public_key
  validates_attachment_content_type :public_key, :content_type => /\Aapplication\/.*\Z/
  
  def save
    valid? && persist!
  end

  def persist!
    engines_api.update_public_key(file_content).was_success
  end

  def file_content
    open(self.public_key.queued_for_write[:original].path).read
  end

end

