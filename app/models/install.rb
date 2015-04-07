class Install < ActiveRecord::Base

  attr_accessor(
    :repository_url, 
    :default_image_url,
    :langauge_name,
    :swframework_name,
    :license_name,
    :license_label,
    :license_sourceurl,
    :gallery_url,
    :gallery_software_id,
    :license_terms_and_conditions,
    :blueprint)

  belongs_to :software

  validate :license_terms_and_conditions_accepted_validation

  def self.new_software_from_gallery(gallery_params)
    new_software_params = new_software_from_gallery_params(gallery_params)
    if new_software_params.nil?
      nil
    else
      Software.new(new_software_params) do |software|
        software.attached_services_handler.load_attached_services_details
      end
    end
  end

  def self.new_software_for_create(new_software_install_params)
    Software.new(new_software_install_params) do |software|
      software.install.load_blueprint
      software.attached_services_handler.load_attached_services_details
    end
  end

  def load_blueprint
    @blueprint ||= (EnginesRepository.blueprint_from_repository repository_url: repository_url).to_json.to_s
  end

private

  def license_terms_and_conditions_accepted_validation
    if license_terms_and_conditions != "1"
      errors.add(:license_terms_and_conditions, ["License", "must be accepted"])
    end
  end
 
  def self.new_software_from_gallery_params(gallery_software_params)
    gallery_software = EnginesGallery.software(gallery_software_params)

    if gallery_software.kind_of?(EnginesOSapiResult) || gallery_software.nil?
      nil
    else
  
      repository_url = gallery_software[:repository_url]
      blueprint = EnginesRepository.blueprint_from_repository repository_url: repository_url

      blueprint_software_params = blueprint[:software]
      software_name = blueprint_software_params['name'].gsub(/[^0-9A-Za-z]/, '').downcase
  
      icon_url = 
        (gallery_software[:icon_url_from_gallery] if gallery_software[:icon_url_from_gallery].present?) ||
        (gallery_software[:icon_url_from_blueprint] if gallery_software[:icon_url_from_blueprint].present?) ||
        (gallery_software[:icon_url_from_repository] if gallery_software[:icon_url_from_repository].present?) ||
        "_placeholder_for_missing_engine.jpg"
  
      {
        engine_name: EnginesInstaller.generate_next_unique_engine_name_for(software_name),
        install_attributes: {
          repository_url: repository_url,
          gallery_url: gallery_software_params[:gallery_url],
          gallery_software_id: gallery_software_params[:gallery_software_id],
          default_image_url: icon_url,
          license_name: blueprint_software_params['license_name'],
          license_label: blueprint_software_params['license_label'],
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
        },
        attached_services_handler_attributes: {attached_services_attributes:
          blueprint_software_params["service_configurations"].map do |attached_service|
            if EnginesAttachedService.service_is_persistant(attached_service["type_path"], attached_service["publisher_namespace"])
              {
                publisher_namespace: attached_service["publisher_namespace"],
                type_path: attached_service["type_path"],
                create_type: :new
              }
            end
          end.compact
        }
      }

    end

  end

end
