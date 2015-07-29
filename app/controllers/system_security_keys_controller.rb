class SystemSecurityKeysController < ApplicationController

  before_action :authenticate_user!
  
  def download
    content = Engines::ApiLoader.instance.engines_api.generate_private_key
    send_data content,  :filename => "engines_private_key.rsa" 
  end

  def new
    @system_security_key = SystemSecurityKey.new
  end
  
  def create
    @system_security_key = SystemSecurityKey.new(system_security_key_params)
    if @system_security_key.save
      redirect_to system_security_path, notice: 'Successfully uploaded public key.'
    else
      render :new
    end
  end
  
private

  def system_security_key_params
    if params[:system_security_key].present?
      params.require(:system_security_key).permit!
    else
      {}
    end
  end

end
