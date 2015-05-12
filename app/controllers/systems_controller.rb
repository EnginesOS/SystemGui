class SystemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @system_info = System.system_info
  end
  
  def update
    if System.update
      redirect_to system_path, notice: "Sucessfully updated system."
    else
      redirect_to system_path, alert: "Unable to update system."
    end  
  end

end