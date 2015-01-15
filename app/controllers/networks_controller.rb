class NetworksController < ApplicationController

  before_action :authenticate_user!

  def edit
    @software = Software.find(params[:id])
    @software.build_network if @software.network.nil?
    @software.network.load_from_api    
  end

  def update
    @software = Software.find(params[:id])
    @software.update_attributes network_params
    if @software.network.save_to_api
      redirect_to control_panel_path, notice: "Network properties were successfully updated for #{@software.engine_name}."
    else
      render :edit # , alert: "Network properties were not updated for #{@software.engine_name}."
    end
  end

private

  def network_params
    params.require(:software).permit!
  end

end