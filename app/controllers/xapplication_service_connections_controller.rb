# class ApplicationServiceConnectionsController < ApplicationController
# 
  # before_action :set_application_service_connection
# 
  # def new
    # render text: params
    # # redirect_to new_application_service_connection_connect_new_path(
      # # application_name: application_name,
      # # application_service_connection: application_service_connection_params,
      # # ) if @application_service_connection.nothing_to_share
  # end
# 
  # def update
    # if @application_service_connection.update(application_service_connection_params)
      # redirect_to control_panel_path, notice: "Successfully updated resources properties for #{@application_service_connection.application_name}."
    # else
      # render :edit
    # end
  # end
# 
# private
# 
  # def set_application_service_connection
    # @application_service_connection ||= @application_service_connections.new(application_service_connection_params)
  # end
# 
  # def application_service_connection_params
    # params.require(:application_service_connection).permit!
  # end
# 
# end


