Rails.application.routes.draw do

  root to: "desktops#show"

  resource :user_passwords


  resource :desktop
  resource :desktop_applications
  resource :control_panel do
    get :services
  end
  resource :control_panel_applications
  resource :control_panel_services
  resource :installer
  resource :services_registry
  resource :system do
    get :monitor, :updater, :restart
  end
  resource :system_restart do
    get :progress
  end
  resource :system_engines_update do
    get :progress
  end
  resource :system_base_update do
    get :progress
  end
  resource :system_security
  resource :system_security_certificate do
    get :download
  end
  resource :system_security_key do
    get :download
  end
  resource :user
  resource :domain
  resources :domains, only: [:index]
  resource :domain_certificate
  resource :domain_settings
  resource :desktop_settings
  resources :galleries
  resource :gallery_software do
    get :tags_list
  end
  resource :gallery_settings
  resource :application_network_properties
  resource :application_resources_properties
  resource :application_variables_properties
  resource :application_display_properties
  resource :application_services_properties
  resource :application_services do
    get :action
  end
  resource :application_report do
    get :installation_report
  end
  resource :application_about
  resource :orphaned_application_service
  resource :application_subservice
  resource :application_uninstall
  resources :applications do
    collection do
      get(
        :start, :stop, :pause, :unpause, :restart,
        :create_container, :destroy_container,
        :reinstall, :delete_image,
        :build, :recreate, :open)
    end
  end
  resource :application_installation do
    get(:preparing_installation, :preparing_installation_progress, :installing, :progress)
  end
  resource :docker_hub_installations
   # do
    # get :application_service
  # end
  # resource :docker_hub_installation_application_services
  resource :repository_url_installations

  resource :service_report
  resource :service_configuration
  resources :services do
    collection do
      get(
        :advanced_detail,
        :pause,
        :unpause,
        :start,
        :stop,
        :restart,
        :show,
        :recreate,
        :create_container,
        :manager)
    end
  end
  devise_for :users, :skip => :registrations

  resource :first_runs do
    get :cancel
  end
  get 'first_run', to: "first_runs#show"

  
end
