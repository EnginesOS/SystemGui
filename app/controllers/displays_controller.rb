class DisplaysController < ApplicationController

  before_action :authenticate_user!

  def edit
    @software = Software.find(params[:id])
  end

  def update
    @software = Software.find(params[:id])
    if @software.update(display_params)
      redirect_to control_panel_path, notice: "successfully updated display properties for #{@software.engine_name}"
    else
      render :edit
    end
  end

private

  def display_params
    params.require(:software).permit!
  end

end
