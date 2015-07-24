class SystemSecurityCertificatesController < ApplicationController

  before_action :authenticate_user!
  
  def download
    content = Engines::ApiLoader.instance.engines_api.get_system_ca
    send_data content,  :filename => "engines_security_certificate.pem" 
  end

  def new
    @system_security_certificate = SystemSecurityCertificate.new
  end
  
  def create
    @system_security_certificate = SystemSecurityCertificate.new(system_security_certificate_params)
    if @system_security_certificate.save
      redirect_to system_security_path, notice: 'Successfully uploaded certificate.'
    else
      render :new
    end
  end
  
private

  def system_security_certificate_params
    params.require(:system_security_certificate).permit!
  end

end
