class ResourcesController < ApplicationController

  before_action :authenticate_user!

  def edit
  end

  def update
    if @runtime.update runtime_params
      redirect_to control_panel_path, notice: "Runtime properties were successfully updated for #{@software.engine_name}."
    else
      render :edit
    end
  end

private

  def runtime_params
    @runtime_params params.require(:runtime).permit!
  end

  def set_runtime
    @runtime = Runtime.find params[:id]
  end

end