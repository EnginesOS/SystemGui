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

  resource :charts do
    get :system_cpu_usage
    get :system_cpu_usage_averages
    get :total_system_memory_usage
    get :total_container_memory_usage
    get :container_memory_usage
    get :total_applications_memory_usage
    get :applications_memory_usage
    get :total_services_memory_usage
    get :services_memory_usage
    get :disk_usage
    get :network_usage
  end
  
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
  resource :system_restart_mgmt do
    get :progress
  end
  resource :system_restart_registry do
    get :progress
  end
  
  resource :system_security
  resource :system_security_certificate do
    get :download
  end
  resource :system_security_key do
    get :new_download
    post :download
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
  resource :application_service do
    get :action
  end
  resource :application_service_connector_type
  resource :application_service_connector_configuration

  resource :application_report do
    get :installation_report
  end
  resource :application_about
  resource :orphaned_application_service
  resource :application_service_connection_subservice_connection
  resource :application_service_connection_subservice_connector_configuration
  resource :application_uninstall
  resource :applications do
    get(
      :start, :stop, :pause, :unpause, :restart,
      :create_container, :destroy_container,
      :reinstall, :delete_image,
      :build, :recreate, :open)
  end

#Services

  resource :service_report
  resource :service_configuration
  resource :services do
    get(
      :pause, :unpause, :start, :stop,
      :restart, :recreate, :create_container) # :show,
  end

#Installer

  resource :installer
  resource :application_installation do
    get(:preparing_installation, :preparing_installation_progress, :installing, :progress)
  end
  resource :install_from_blueprint
  resource :install_from_repository_url
  resource :install_from_docker_hub
  resource :install_from_docker_hub_configuration
   # do
    # get :application_service
  # end
  # resource :docker_hub_installation_application_services

#First run

  resource :first_run do
    get :cancel
  end

#Help

  resource :help
  
end
