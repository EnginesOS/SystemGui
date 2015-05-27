class ApplicationUninstall

  include ActiveModel::Model
  include Engines::Api

  attr_accessor :remove_all_data, :application_name

  def uninstall
    engines_api.deleteEngineImage( application_name, remove_all_data: ( remove_all_data == '1' ) ).was_success
  end

end