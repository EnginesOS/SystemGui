class WelcomeController < ApplicationController

  before_action :authenticate_user!

  include Engines::FirstRun

  def start
    # Maintenance.full_maintenance
    if FirstRun.required?
      redirect_to(first_runs_path)
    else
      redirect_to(desktop_path)
    end
  end      

end
