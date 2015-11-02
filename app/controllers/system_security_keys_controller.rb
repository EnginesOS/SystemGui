class SystemSecurityKeysController < ApplicationController

  def new_download
    @system_security_key = SystemSecurityKey.new
  end
  
  def download
    if current_user.valid_password?(system_security_key_params[:admin_password])
      result = Engines::ApiLoader.instance.engines_api.generate_private_key
      if result.is_a? EnginesOSapiResult
        redirect_to new_download_system_security_key_path, alert: 'Engines API error. ' + (result.result_mesg)
      else
        send_data content,  :filename => "engines_private_key.rsa"
      end
    else
      redirect_to new_download_system_security_key_path, alert: 'Admin password incorrect'
    end
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
    # if params[:system_security_key].present?
      params.require(:system_security_key).permit!
    # else
      # {}
    # end
  end

end
