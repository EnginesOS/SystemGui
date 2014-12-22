class ServicesController < ApplicationController

  include EnginesServicesActions

  before_action :authenticate_user!

  def advanced_detail
    @service_name = params[:id]
    render partial: "advanced_detail"
  end

end

