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
      variables_attributes: repository_software_params["environment_variables"],
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