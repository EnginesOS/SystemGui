class ApplicationInstallationProgress

  # require 'json'
  include Engines::Api
  include ActiveModel::Model

  attr_accessor( 
    :software_name,
    :application_name,
    :host_name,
    :domain_name)


  def installation_report_lines
    engines_api.get_engine_build_report(application_name).split("\n")
  end

end
