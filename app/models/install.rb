class Install < ActiveRecord::Base

  attr_accessor(
    :repository_url, 
    :default_image_url,
    :langauge_name,
    :swframework_name,
    :license_name,
    :license_sourceurl,
    :gallery_url,
    :software_id,
    :license_terms_and_conditions)

  belongs_to :software

  validates :license_terms_and_conditions, acceptance: { is: true }

  def self.new_software gallery_software_params
    Software.new(new_software_params(gallery_software_params))
  end

  def self.engine_build_params software

p "======================================"
p software


result = {
  engine_name: software.engine_name,
  host_name: software.network.host_name,
  domain_name: software.network.domain_name,
  http_protocol: software.network.http_protocol,
  memory: software.resource.memory,
  software_environment_variables: (software_variables_params(software.software_variable)),
  repository_url: software.install.repository_url
}

p "======================================"
p result

result

  end

  def self.software_variables_params software_variable
    return nil if software_variable.nil?
    result = []
    software_variable.variables.each do |variable|
      result << {
       name: variable.name,
       value: variable.value
      }
    end
    result
  end




private

  def self.new_software_params(gallery_software_params)
    gallery_software = EnginesGallery.software(gallery_software_params)
    repository_url = gallery_software["repository"]
    repository_software_params = EnginesRepository.software_params repository_url: repository_url
    software_name = repository_software_params['name'].gsub(/[^0-9A-Za-z]/, '').downcase
    {
      engine_name: EnginesInstaller.generate_next_unique_engine_name_for(software_name),
      install_attributes: {
        repository_url: repository_url,
        gallery_url: gallery_software_params[:gallery_url],
        software_id: gallery_software_params[:software_id],
        default_image_url: gallery_software['image_url'],
        license_name: repository_software_params['license_name'],
        license_sourceurl: repository_software_params['license_sourceurl']
      },
      display_attributes: {
        display_name: repository_software_params['name'],
        display_description: repository_software_params['description']
      },
      software_variable_attributes: {variables_attributes: repository_software_params["environment_variables"]},
      network_attributes: {
        host_name: EnginesInstaller.generate_next_unique_host_name_for(software_name),
        domain_name: Network.best_default_domain,
        http_protocol: Network.best_http_protocol(repository_software_params['http_protocol'])
      },
      resource_attributes: {
        required_memory: repository_software_params['requiredmemory'],
        memory: repository_software_params['recommended_memory'] || repository_software_params['requiredmemory']
      }
    }
  end

end
