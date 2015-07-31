Rails.application.routes.draw do

  devise_for :users, :skip => :registrations
  resource :user_passwords
  # mount RailsAdmin::Engine => '/admin', as: :rails_admin
  root to: "desktops#show"



  resource :desktop
  resource :desktop_applications
  resource :control_panel
  resource :control_panel_applications
  resource :control_panel_services
  resource :installer
  resource :services_registry
  resource :system do
    get(:monitor, :restart, :restarting, :engines_update)
  end
  resource :system_update do
    get(:update_base, :update_engines)
  end
  resource :system_security
  resource :system_security_certificate do
    get :download
  end
  resource :system_security_key do
    get :download
  end
  resource :user
  # resources :backup_tasks
  resource :domain
  resources :domains, only: [:index]
  resource :domain_certificate
  resource :domain_settings
  resource :desktop_settings
  resources :galleries
  resource :gallery_software
  resource :gallery_settings
  resource :application_network_properties
  resource :application_resources_properties
  resource :application_variables_properties
  resource :application_display_properties
  resource :application_services_properties
  resource :application_services do
    get :action
  end
  resource :application_report
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
        :build, :recreate)
    end
  end
  resource :application_installation do
    get(:installing, :set_installing_params, :progress)
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

  resource :first_runs do
    get :cancel
  end
  get 'first_run', to: "first_runs#show"

  
end
