module Engines::FirstRun

  extend Engines::Api

    def self.application_container_names_list
      engines_api.list_apps.sort
    end

    def self.required?
      engines_api.first_run_required?
    end
  
    def self.submit(params)
      engines_api.set_first_run_parameters params
    end

end