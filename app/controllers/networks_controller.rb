class NetworksController < ApplicationController

  before_action :authenticate_user!

  def edit
    @software = Software.find(params[:id])
    @software.build_network if @software.network.nil?
    @software.network.load_from_api    
  end

  def update

# @software = Software.find(params[:id])
# @software.update_attributes network_params
# @software.network.valid?
# render text: EnginesSoftware.fqdn(@software.engine_name)

    @software = Software.find(params[:id])
    @software.update_attributes network_params
    if @software.network.valid?
      result = @software.network.save_to_api
      if result
        redirect_to control_panel_path, notice: "Network properties were successfully updated for #{@software.engine_name}."
      else
        redirect_to control_panel_path, alert: "Network properties were not updated for #{@software.engine_name}. " + result.error_mesg[250]
      end
    else
      render :edit
    end
  end

private

  def network_params
    params.require(:software).permit!
  end

end