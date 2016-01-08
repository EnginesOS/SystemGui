class ServiceActionsController < ApplicationController

  def index
    @service_name = params[:service_name]
    @service_actionators = ServiceAction.list_actionators_for params[:service_name]
  end

  def show
    @service_action = ServiceAction.new(params)
    render layout: false
  end

end
