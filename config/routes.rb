Rails.application.routes.draw do

  root to: "desktops#show"

#Navbar

  resource :navbar_system_status

#Users

  get 'sign_in', to: redirect('/users/sign_in')

  devise_for :users, skip: :registrations, :controllers => { :sessions => "user_sessions" }
  resource :user, only: :show
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  # resource :user_password

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
  resource :control_panel_applications_states
  resource :control_panel_services_states

#System

  resource :system_monitor_charts do
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

  resource :system_monitor_charts

  resource :system do
    get :monitor, :status, :info, :logs, :base_system, :updater, :restart
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
  resource :system_bug_reports

#Domains

  resource :domains_manager
  resource :domain
  resource :domain_certificate
  resource :domain_default_name
  resource :domain_default_site

#Display settings

  resource :display_settings

#Libraries

  resources :libraries
  resource :library_software do
    get :tags_list
  end
  resource :library_settings

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
  resource :application_action do
    get :perform
  end
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
      :start_container, :stop_container, :pause_container, :unpause_container, :restart_container,
      :create_container, :destroy_container, :recreate_container,
      :reinstall, :open_first_run, :reload)
  end

#Services

  resource :service_report
  resource :service_configuration
  resource :service_action do
    get :perform
  end
  resource :services do
    get(
      :pause_container, :unpause_container, :start_container, :stop_container,
      :restart_container, :recreate_container, :create_container, :reload) # :show,
  end

#Installer

  resource :installer
  resource :application_installation do
    get(:preparing_installation, :preparing_installation_progress, :installing,
     :progress, :cancel)
  end
  resource :install_from_blueprint
  resource :install_from_repository_url
  resource :install_from_docker_hub
  resource :install_from_docker_hub_configuration

#First run

  resource :first_run do
    get :cancel
  end

#Help

  resource :help

end
