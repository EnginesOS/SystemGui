class ApplicationServiceDataExportsController < ApplicationController

  include Engines::Api

  def show
    result = engines_api.export_service connection_params
    if result.is_a? EnginesOSapiResult
      redirect_to system_security_path, alert: 'Engines API error. ' + (result.result_mesg)
    else
      send_data result,
       :filename => "#{connection_params[:service_handle]}_#{connection_params[:type_path].split('/').last}_#{Time.zone.now.to_s.gsub(':', '-').sub(' ', '_').sub(' ', '-')}.data"
    end
  end

private

  def connection_params
    params.require(:connection_params).permit!
  end

end
