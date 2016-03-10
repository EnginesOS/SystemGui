class ApplicationActionsController < ApplicationController

  def show
    @application = Application.load_by_container_name params[:application_name]
  end

  def new
    @application = Application.load_by_container_name params[:application_name]
    @application_action = @application.build_action_for params[:action_name]
    if @application_action.variables.empty?
      redirect_to perform_application_action_path(application_name: params[:application_name],
        application_action: {
          name: @application_action.name,
          label: @application_action.label,
          return_type: @application_action.return_type})
    end
  end

  def create
    @application = Application.load_by_container_name params[:application_name]
    @application_action = ApplicationAction.new(application: @application)
    @application_action.assign_attributes(application_action_params)
    if @application_action.valid?
      redirect_to perform_application_action_path(application_name: params[:application_name], application_action: application_action_params)
    else
      render :new
    end
  end

  def perform
    @application = Application.load_by_container_name params[:application_name]
    @application_action = ApplicationAction.new(application: @application)
    @application_action.assign_attributes(application_action_params)
    if @application_action.perform_action
      case @application_action.return_type.to_sym
      when :file
        send_data @application_action.action_result,
        filename: @application_action.return_file_name || "engines_#{@application_action.application.container_name}_#{@application_action.name}"
      when :none
        redirect_to application_action_path(application_name: params[:application_name]), notice: "Successfully performed action #{@application_action.label}."
      else
        render :perform
      end
    else
      redirect_to application_action_path(application_name: params[:application_name]),
        alert: 'Engines API error. ' + (@application_action.engines_api_error)
    end
  end


private

  def application_action_params
    params.require(:application_action).permit!
  end

end
