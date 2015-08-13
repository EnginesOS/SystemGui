class ApplicationUninstall

  include ActiveModel::Model
  include Engines::Api

  attr_accessor :remove_all_data, :application_name, :engines_api_error

  def uninstall
    result = engines_api.deleteEngineImage( engine_name: application_name, remove_all_data: ( remove_all_data == '1' ) )
    if result.was_success
      @engines_api_error = "result was true."
      true
    else
      @engines_api_error = (result.result_mesg.present? ? result.result_mesg : "Uninstall failed. No result message given by engines api.")
      false
    end    
  end

end