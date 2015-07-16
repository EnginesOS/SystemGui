class WelcomeController < ApplicationController

  before_action :authenticate_user!

  include Engines::FirstRun

  def start
    # Maintenance.full_maintenance
    
    render text: FirstRun.required?
    # if FirstRun.required?
      # redirect_to(first_runs_path)
    # else
      # redirect_to(desktop_path)
    # end
  end      

end
