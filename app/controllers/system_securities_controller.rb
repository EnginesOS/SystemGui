class SystemSecuritiesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @certificate = SystemSecurityCertificate.new
    @public_key = SystemSecurityKey.new
  end

  def access_key_download
    content = Engines::ApiLoader.instance.engines_api.generate_private_key
    send_data content,  :filename => "engines_private_key.rsa" 
  end

  def access_key_upload
    
  end

  def certificate_download
    content = Engines::ApiLoader.instance.engines_api.get_system_ca
    send_data content,  :filename => "engines_security_certificate.pem" 
  end

  def certificate_upload
    
  end

end
