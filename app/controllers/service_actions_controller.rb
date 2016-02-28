class ServiceActionsController < ApplicationController

  def show
    @service = Service.load_by_container_name params[:service_name]
  end

  def new
    @service = Service.load_by_container_name params[:service_name]
    @service_action = @service.build_action_for params[:action_name]
    if @service_action.variables.empty?
      redirect_to perform_service_action_path(service_name: params[:service_name],
        service_action: {
          name: @service_action.name,
          label: @service_action.label,
          return_type: @service_action.return_type})
    end
  end

  def create
    @service = Service.load_by_container_name params[:service_name]
    @service_action = ServiceAction.new(service: @service)
    @service_action.assign_attributes(service_action_params)
    if @service_action.valid?
      redirect_to perform_service_action_path(service_name: params[:service_name], service_action: service_action_params)
    else
      render :new
    end
  end

  def perform
    @service = Service.load_by_container_name params[:service_name]
    @service_action = ServiceAction.new(service: @service)
    @service_action.assign_attributes(service_action_params)
    if @service_action.perform_action
      case @service_action.return_type.to_sym
      when :file
        send_data @service_action.action_result, filename: "engines_#{@service_action.service.container_name}_#{@service_action.name}"
      when :none
        redirect_to service_action_path(service_name: params[:service_name]), notice: "Successfully performed action #{@service_action.label}."
      else
        render :perform
      end
    else
      redirect_to service_action_path(service_name: params[:service_name]),
        alert: 'Engines API error. ' + (@service_action.engines_api_error)
    end
  end


private

  def service_action_params
    params.require(:service_action).permit!
  end

end
