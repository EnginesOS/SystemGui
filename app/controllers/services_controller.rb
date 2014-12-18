class ServicesController < ApplicationController

  include EnginesServicesActions

  before_action :authenticate_user!

  def advanced_detail
    @engines_service = EnginesService.engines_service params[:id]
    render partial: "advanced_detail"
  end

end

