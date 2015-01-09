class SoftwaresController < ApplicationController

  include EnginesSoftwaresActions

  before_action :authenticate_user!

  # before_action :set_softwares, only: :index
  # before_action :set_software,
  #   only: [
  #     :edit_display_properties,
  #     :edit_runtime,
  #     :edit_network_properties,
  #     :edit_software_variables,
  #     # :show_about_properties,
  #     :share_folders,
  #     :update_display_properties,
  #     :update_network_properties,
  #     :update_runtime,
  #     :update_software_variables]
  
  def index
    @softwares = Software.all
  end

  def destroy_all_records
    Software.delete_all
    redirect_to softwares_path 
  end

  

#   def new
#     EnginesMaintenance.db_maintenance
#     @software = Software.new_from_repository gallery_url: software_params["gallery_url"], software_id: software_params["software_id"]
#   end

  def create
p :software_params
p software_params

    # if software_params["terms_and_conditions_accepted"] == "0"
    #   redirect_to new_software_path(software: software_params), alert: "You must accept the license terms and conditions to install this software."
    # elsif EnginesInstaller.engine_name_not_unique?(software_params[:engine_name])
    #   redirect_to new_software_path(software: software_params), alert: "Engine name must be unique."
    # elsif EnginesInstaller.fqdn_not_unique?(software_params[:host_name] + '.' + software_params[:domain_name])
    #   redirect_to new_software_path(software: software_params), alert: "Host name plus domain name must be unique."
    # elsif EnginesInstaller.software_variable_passwords_not_confimed?(software_environment_variable_params_with_password_confirmations)
    #   redirect_to new_software_path(software: software_params), alert: "Password did not match password confirmation."
    # else

    @software = Software.new(software_params)
      if @software.save
        if @software.icon.exists? == false
          @software.attach_default_icon
          @software.save
        end
        redirect_to engine_install_path(software_params)
      else
        render :new
        # redirect_to installer_path, alert: "Unable to initiate application installation for #{@software.engine_name}. Failed to save display properties to database."
      end
    # end
  end

#   def install

# p :software_engine_install_params
# p software_engine_install_params

#     install_response = EnginesInstaller.install_engines_software software_engine_install_params
#     if install_response.instance_of?(ManagedEngine)
#       redirect_to control_panel_path, notice: "Application installation was successful for #{params[:id]}."
#     elsif install_response.instance_of?(EnginesOSapiResult)
#       redirect_to installer_path, alert: "Application installation was not successful for #{params[:id]}. " + install_response.result_mesg[0..1000]
#     else
#       render text: "Unexpected response from software installation process for #{params[:id]}."
#     end
#   end

#   def edit_software_variables
#   end

#   def edit_network_properties
#     render "network/edit"
#   end

#   def edit_software_variables
#   end


#   def update_display_properties
#     if @software.update_display_properties software_params
#       redirect_to control_panel_path, notice: "Display properties were successfully updated for #{@software.engine_name}."
#     else
#       render :edit_display_properties
#     end
#   end

#   def update_network_properties
#     if EnginesInstaller.fqdn_not_unique?(software_params[:host_name] + '.' + software_params[:domain_name])
#       redirect_to new_software_path(software: software_params), alert: "Host name plus domain name must be unique."
#     else
#       if @software.update_network_properties software_params
#         redirect_to control_panel_path, notice: "Network properties were successfully updated for #{@software.engine_name}."
#       else
#         render :edit_network_properties
#       end
#     end
#   end

#   def update_runtime
#     if @software.update_runtime software_params
#       redirect_to control_panel_path, notice: "Runtime properties were successfully updated for #{@software.engine_name}."
#     else
#       render :edit_runtime
#     end
#   end

#   def update_software_variables
#     if EnginesInstaller.software_variable_passwords_not_confimed?(software_environment_variable_params_with_password_confirmations)
#       redirect_to new_software_path(software: software_params), alert: "Password did not match password confirmation."
#     else
#       if @software.update_software_variables software_params
#         redirect_to control_panel_path, notice: "Runtime properties were successfully updated for #{@software.engine_name}."
#       else
#         render :edit_runtime
#       end
#     end
#   end

  def advanced_detail
    @engine_name = params[:id]
    render partial: "advanced_detail"
  end

private

  def software_engine_install_params
    result = {}
    software_params.each do |k,v|
      if v.kind_of? Hash
        v.each do |k,v|
          result[k.to_sym] = v
        end
      else
        result[k.to_sym] = v
      end
    end
p :software_engine_install_params
p result

    result
  end

  def software_params
    @software_params ||= params_without_password_confirmations
  end

  def software_environment_variable_params_with_password_confirmations
    params.require(:software)["software_environment_variables_attributes"]
  end

  def params_without_password_confirmations
    software_params_temp = params.require(:software).permit!

p :software_params_temp
p software_params_temp

    if software_params_temp["software_environment_variables_attributes"].present?
      software_params_temp["software_environment_variables_attributes"].each do |k,v|
          { k => (v.delete("password_confirmation"); v) }
      end
    end
    software_params_temp


  end

  def set_software
    @software = Software.find params[:id]
  end

  def load_software_display_properties
    @software.load_engines_software_display_parameters
  end

  def load_network
    @software.build_network
    @software.network.load_engines_network
  end

  def load_runtime
    @software.build_runtime
    @software.runtime.load_engines_runtime
  end

  def load_software_variables
    @software.build_software_environment_variables
    @software.software_environment_variables.load_engines_software_environment_variables
  end

end