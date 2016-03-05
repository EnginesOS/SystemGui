class SystemSecurityCertificatesController < ApplicationController

  include Engines::Api

  def download
    result = engines_api.get_system_ca
    if result.is_a? EnginesOSapiResult
      redirect_to system_security_path, alert: 'Engines API error. ' + (result.result_mesg)
    else
      send_data result,  :filename => "engines_security_certificate.pem"
    end
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
