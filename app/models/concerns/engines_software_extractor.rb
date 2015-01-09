module EnginesSoftwareExtractor

  def blueprint_software_details(engine_name)
    @blueprint_software_details = blueprint(engine_name)['software']

p :@blueprint_software_details
p engine_name
p @blueprint_software_details

@blueprint_software_details


  end

  # def repository_url engine_name(engine_name)
  #   blueprint(engine_name)["repository"]
  # end

  def blueprint_software_name(engine_name)
    blueprint_software_details(engine_name)['name']
  end

  def environment_variables(engine_name)
    blueprint_environment_variables = blueprint_software_details(engine_name)['environment_variables']
    environments(engine_name).map(&:attributes).each do |environment_variable|

p :environment_variable
p environment_variable 

p :blueprint_environment_variables
p blueprint_environment_variables

      blueprint_environment_variable = blueprint_environment_variables.find do |ev|
        ev["name"] == environment_variable[:name]
      end



p :blueprint_environment_variable
p blueprint_environment_variable


      environment_variable[:label] = blueprint_environment_variable["label"]
      environment_variable[:comment] = blueprint_environment_variable["comment"] 
      environment_variable[:type] = blueprint_environment_variable["type"] 
      environment_variable[:regex_validator] = blueprint_environment_variable["regex_validator"] 
      environment_variable[:mandatory] = blueprint_environment_variable["mandatory"] 
      environment_variable[:collection] = blueprint_environment_variable["collection"] 
      environment_variable[:ask_at_build_time] = blueprint_environment_variable["ask_at_build_time"] 
      environment_variable[:build_time_only] = blueprint_environment_variable["build_time_only"] 
      environment_variable[:immutable] = blueprint_environment_variable["immutable"] 
    end
  end

  def volumes(engine_name)
    volumes_hash(engine_name).values
  end

  def consumers(engine_name)
    consumers_hash(engine_name).values
  end

  # def databases(engine_name)
  #   databases_hash(engine_name)
  # end

  def backup_tasks(engine_name)
    EnginesBackupTask.all #.select { |backup_task| backup_task.present? }
  end

end