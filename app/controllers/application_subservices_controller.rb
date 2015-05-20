class ApplicationSubservicesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_application_subservice

  # def edit
    # @application_subservice.build
  # end

  def new
    @application_subservice.load
  end

  def create
    # render text: params

    # @application_subservice.assign_attributes(application_subservice_params)
    if @application_subservice.create
        redirect_to services_properties_path(application_name: @application_subservice.application_name),
          notice: "Successfully attached #{@application_subservice.title} to #{@application_subservice.parent_title} on #{@application_subservice.application_name}."
    else
      render :new
    end
  end



private

  def set_application_subservice
    @application_subservice ||= ApplicationSubservice.new application_subservice_params
  end
      
  # def application_name
    # params[:application_name]
  # end

  def application_subservice_params
    params.require(:application_subservice).permit!
  end

end


