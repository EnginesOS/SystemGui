module EnginesSoftwareLoader

  def engines_software engine_name
    engines_api.loadManagedEngine engine_name
  end

  def blueprint engine_name
    engines_api.get_engine_blueprint engine_name
  end

  def all_engine_names
    engines_api.list_apps
  end

  def all_host_names
    all.map(&:host_name)
  end

  def user_visible_applications
    all = self.all
    running_apps = []
    all.each do |app|
      if app.state_as_set_by_user == 'running'
        running_apps << app
      end
    end
    return running_apps
  end

  def count
    all_engine_names.count
  end

end