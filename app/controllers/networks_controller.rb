class NetworksController < ApplicationController

  before_action :authenticate_user!

  def edit
  end

  def update
    if EnginesInstaller.fqdn_not_unique?(network_params[:host_name] + '.' + network_params[:domain_name])
      redirect_to new_software_path(software: network_params), alert: "Host name plus domain name must be unique."
    else
      if @network.update network_params
        redirect_to control_panel_path, notice: "Network properties were successfully updated for #{@software.engine_name}."
      else
        render :edit
      end
    end
  end

private

  def network_params
    @network_params params.require(:network).permit!
  end

  def set_network
    @network = Network.find params[:id]
  end

end