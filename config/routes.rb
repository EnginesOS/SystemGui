Rails.application.routes.draw do

  root to: "desktops#show"

#Users

  resource :user
  resource :user_password
  devise_for :users, :skip => :registrations

#Desktop

  resource :desktop
  resource :desktop_applications

#Control panel

  resource :control_panel do
    get :services
  end
  resource :control_panel_applications
  resource :control_panel_services
  resource :services_registry

#System

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

#Domains

  resource :domains_manager
  resource :domain
  resource :domain_certificate
  resource :domain_settings

#Desktop settings
  
  resource :desktop_settings

#Libraries

  resources :galleries
  resource :gallery_software do
    get :tags_list
  end
  resource :gallery_settings

#Applications

  resource :application_network_properties
  resource :application_resources_properties
  resource :application_variables_properties
  resource :application_display_properties
  resource :application_services_properties
  resource :application_services do
    get :action
  end
  namespace :application_services do
    resource :connect_service
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

#Services

  resource :service_report
  resource :service_configuration
  resources :services do
    collection do
      get(
        :pause, :unpause, :start, :stop,
        :restart, :recreate, :create_container ) # :show,
    end
  end

#Installer

  resource :installer
  resource :application_installation do
    get(:preparing_installation, :preparing_installation_progress, :installing, :progress)
  end
  resource :install_from_blueprint
  resource :install_from_repository_url
  resource :install_from_docker_hub
   # do
    # get :application_service
  # end
  # resource :docker_hub_installation_application_services

#First run

  resource :first_run do
    get :cancel
  end
  # get 'first_runs', to: "first_runs#show" #first_runs deprecated in favour of first_run

#Help

  resource :help
  
end
