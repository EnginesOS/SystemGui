class SystemSecurityCertificate < ActiveRecord::Base

  include Engines::Api

  has_attached_file :certificate
  attr_accessor :domain_name, :key

  validates_attachment_content_type :certificate, :content_type => /\Aapplication\/.*\Z/
  validates_attachment_presence :certificate
  validates :domain_name, presence: true
  validates :key, presence: true
  
  def save
    valid? && persist!
  end

  def persist!
    engines_api.upload_ssl_certificate(persist_params).was_success
  end

  def file_content
    open(self.certificate.queued_for_write[:original].path).read
  end

  def persist_params
    {
      domain_name: domain_name,
      key: key,
      certificate: file_content
    }
  end

end