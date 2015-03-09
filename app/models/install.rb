class Install < ActiveRecord::Base

  attr_accessor(
    :repository_url, 
    :default_image_url,
    :langauge_name,
    :swframework_name,
    :license_name,
    :license_sourceurl,
    :gallery_url,
    :gallery_software_id,
    :license_terms_and_conditions,
    :blueprint)

  belongs_to :software

  validate :license_terms_and_conditions_accepted_validation

  def self.new_software_from_gallery(gallery_params)



    Software.new(new_software_from_gallery_params(gallery_params))
  end

  # def self.new_software_from_params(software_install_params)
  #   Software.new(new_software_params(software_install_params))
  # end

  def self.engine_build_params(software)
    {
      engine_name: software.engine_name,
      host_name: software.network.host_name,
      domain_name: software.network.domain_name,
      http_protocol: software.network.http_protocol,
      memory: software.resource.memory,
      software_environment_variables: (software_variables_params(software.software_variables_handler)),
      repository_url: software.install.repository_url
    }
  end

private

  def license_terms_and_conditions_accepted_validation
    if license_terms_and_conditions != "1"
      errors.add(:license_terms_and_conditions, ["License", "must be accepted"])
    end
  end



 
  def self.new_software_from_gallery_params(gallery_software_params)
    gallery_software = EnginesGallery.software(gallery_software_params)

p :gallery_software
p gallery_software
p :gallery_software_params
p gallery_software_params


    repository_url = gallery_software[:repository_url]
    blueprint = EnginesRepository.blueprint_from_repository repository_url: repository_url
    blueprint_software_params = blueprint[:software]
    software_name = blueprint_software_params['name'].gsub(/[^0-9A-Za-z]/, '').downcase

p :blueprint_software_params
p blueprint_software_params



p :engine_name
p EnginesInstaller.generate_next_unique_engine_name_for(software_name)
p :repository_url
p repository_url
p :gallery_url
p gallery_software_params[:gallery_url]
p :gallery_software_id
p gallery_software_params[:gallery_software_id]
p :default_image_url
p gallery_software[:icon_url_from_repository]
p :license_name
p blueprint_software_params['license_name']
p :license_sourceurl
p blueprint_software_params['license_sourceurl']
p :license_terms_and_conditions
p false
p :blueprint
p blueprint
p :display_name
p blueprint_software_params['name']
p :display_description
p blueprint_software_params['description']
p :variables_attributes
p blueprint_software_params["environment_variables"]
p :host_name
p EnginesInstaller.generate_next_unique_host_name_for(software_name)
p :domain_name
p Network.best_default_domain
p :http_protocol
p Network.best_http_protocol(blueprint_software_params['http_protocol'])
p :required_memory
p blueprint_software_params['requiredmemory']
p :memory
p blueprint_software_params['recommended_memory'] || blueprint_software_params['requiredmemory']





    {
      engine_name: EnginesInstaller.generate_next_unique_engine_name_for(software_name),
      install_attributes: {
        repository_url: repository_url,
        gallery_url: gallery_software_params[:gallery_url],
        gallery_software_id: gallery_software_params[:gallery_software_id],
        default_image_url: gallery_software[:icon_url_from_repository],
        license_name: blueprint_software_params['license_name'],
        license_sourceurl: blueprint_software_params['license_sourceurl'],
        license_terms_and_conditions: false,
        blueprint: blueprint.to_json.to_s
      },
      display_attributes: {
        display_name: blueprint_software_params['short_title'],
        display_description: blueprint_software_params['description']
      },
      software_variables_handler_attributes: {variables_attributes: blueprint_software_params["variables"]},
      network_attributes: {
        host_name: EnginesInstaller.generate_next_unique_host_name_for(software_name),
        domain_name: Network.best_default_domain,
        http_protocol: Network.best_http_protocol(blueprint_software_params['http_protocol'])
      },
      resource_attributes: {
        required_memory: blueprint_software_params['required_memory'],
        memory: blueprint_software_params['recommended_memory'] || blueprint_software_params['requiredmemory']
      }
    }
  end

  # def self.new_software_params(software_install_params)
  #   gallery_software_params = new_software_from_gallery_params(
  #     gallery_url: software_install_params["install_attributes"]["gallery_url"], 
  #     gallery_software_id: software_install_params["install_attributes"]["gallery_software_id"])
  #   gallery_software_params[:software_variables_handler_attributes][:variables_attributes]
  #   @software.install.update_install(software_install_params)
  # end

  def self.software_variables_params software_variables_handler
    return nil if software_variables_handler.nil?
    result = []
    software_variables_handler.variables.each do |variable|
      result << {
       name: variable.name,
       value: variable.value
      }
    end
    result
  end




end
