module Engines::FirstRun

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def engines_api
      Engines::Api.instance.engines_api
    end

    def application_container_names_list
      engines_api.list_apps.sort
    end

    def required?
      engines_api.first_run_required?
    end
  
    def submit(params)
      engines_api.set_first_run_parameters params
    end

  end

end