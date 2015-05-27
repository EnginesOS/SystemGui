class DomainCertificate < ActiveRecord::Base

  # extend Engines::Api
# 
  # attr_accessor(
    # :country,
    # :state,
    # :city,
    # :organization_name,
    # :person_name,
    # :certificate)
# 
  # attr_accessor :delete_certificate_file
  # has_attached_file :certificate_file, dependent: :destroy
  # validates_attachment_content_type :certificate_file #, :content_type => /\Aimage\/.*\Z/
  # before_validation { certificate_file.clear if delete_certificate_file == '1' }
# 
  # validates :country,
            # :state,
            # :city,
            # :organization_name,
            # :person_name, presence: true
#     
  # def self.load domain_key
    # new(domain_key: domain_key)
  # end
# 
  # def self.load_all
    # engines_api.certificates
  # end
# 
  # def domain_name
    # @domain_name ||= Domain.key_to_domain_name domain_key
  # end
# 
  # def create domain_certificate_params
    # assign_attributes domain_certificate_params
    # valid? && create_certificate
  # end
#     
  # def create_certificate
    # self.class.engines_api.create_ssl_certificate(
      # domain_name: domain_name,
      # person_name: person_name,
      # organization_name: organization_name,
      # city: city,
      # state: state,
      # country: country).was_success
  # end

end