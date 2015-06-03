Rails.application.routes.draw do

  devise_for :users, :skip => :registrations
  resource :user_passwords
  # mount RailsAdmin::Engine => '/admin', as: :rails_admin
  root to: "welcome#start"

  # get "help", to: "pages#help"
  # get "system/update", to: "system#system_update"
  # get "settings/edit_mail", to: "settings#edit_mail"
  # get "installs/cancel", to: "installs#cancel_installation", as: :cancel_installation
  # get "installs/docker_hub_install", to: "docker_hub_installs#new", as: :new_docker_hub_install
  # post "installs/docker_hub_install", to: "docker_hub_installs#create", as: :create_docker_hub_install
  # get "/installs/docker_hub_install_attach_service", to: "docker_hub_installs#new_attached_service", as: :docker_hub_install_attach_service
  # get "/services/delete_orphaned_attached_service", to: "services#delete_orphaned_attached_service", as: :delete_orphaned_attached_service
  # get "/services/delete_all_orphaned_attached_services", to: "services#delete_all_orphaned_attached_services", as: :delete_all_orphaned_attached_services

  resource :first_run
  resource :desktop
  resource :desktop_applications
  resource :control_panel
  resource :control_panel_applications
  resource :control_panel_services
  resource :installer
  resource :services_registry
  resource :system
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
  resource :network_properties
  resource :resources_properties
  resource :variables_properties
  resource :display_properties
  resource :application_report
  resource :application_about
  # resource :services_properties
  resource :application_services
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
    get(:installing, :progress)
  end
  resource :docker_hub_installations
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
  
end
