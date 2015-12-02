class ApplicationInstallationProgress

  include Engines::Api
  include ActiveModel::Model

  attr_accessor( 
    :application_name,
    :host_name,
    :domain_name)

  def self.load
    new(System.installing_params)
  end

  def installation_report_lines
    engines_api.get_engine_build_report(application_name).split("\n")
  end

end
