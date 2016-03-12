class ApplicationServiceDataImportsController < ApplicationController

  include Engines::Api

  def show
    @application_service_data_import = ApplicationServiceDataImport.new(application_service_data_import_params)
  end

  def create
    @application_service_data_import = ApplicationServiceDataImport.new(application_service_data_import_params)
    if @application_service_data_import.save
      redirect_to application_services_properties_path(application_service_data_import_params[:application_name]),
        notice: 'Successfully uploaded data.'
    else
      render :show
    end
  end

private

  def application_service_data_import_params
    params.require(:application_service_data_import).permit!
  end

end
