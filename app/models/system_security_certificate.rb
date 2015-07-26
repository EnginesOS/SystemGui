class SystemSecurityCertificate < ActiveRecord::Base

  include Engines::Api

  has_attached_file :certificate
  validates_attachment_content_type :certificate, :content_type => /\Aapplication\/.*\Z/
  
  def save
    valid? && persist!
  end

  def persist!
    engines_api.upload_ssl_certificate(file_content).was_success
  end

  def file_content
    open(self.certificate.queued_for_write[:original].path).read
  end

end