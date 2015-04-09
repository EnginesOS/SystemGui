Rails.application.routes.draw do

  devise_for :users, :skip => :registrations

  mount RailsAdmin::Engine => '/admin', as: :rails_admin

  root to: redirect("/start")

  get "first_run", to: "first_runs#first_run"
  post "first_runs", to: "first_runs#submit_first_run"
  get "start", to: "pages#start"
  get "desktop", to: "pages#desktop"
  get "control_panel", to: "pages#control_panel"
  get "help", to: "pages#help"
  get "system", to: "pages#system"
  # get "install_progress", to: "installs#progress"
  # get "settings", to: "settings#index"
  get "domains/edit_default_domain", to: "domains#edit_default_domain"
  get "domains/edit_default_website", to: "domains#edit_default_website"
  patch "domains/update_network_settings", to: "domains#update_network_settings"
  get "settings/edit_mail", to: "settings#edit_mail"
  get "settings/edit_wallpaper", to: "settings#edit_wallpaper"
  get "installer", to: "installs#installer"
  # get "engine_install", to: "installs#engine_install", as: :engine_install
  get "domains/:id/new_ssl_certificate", to: "domains#new_ssl_certificate", as: :new_domain_ssl_certificate
  patch "domains/:id/create_ssl_certificate", to: "domains#create_ssl_certificate", as: :create_domain_ssl_certificate
  get "installs/gallery_software", to: "installs#gallery_software"
  get "services/registry", to: "services#registry"
  get "installs/progress/:engine_name", to: "installs#progress", as: :installation_progress
  get "installs/cancel", to: "installs#cancel_installation", as: :cancel_installation
  get "installs/docker_hub_install", to: "docker_hub_installs#new", as: :new_docker_hub_install
  post "installs/docker_hub_install", to: "docker_hub_installs#create", as: :create_docker_hub_install
  get "installs/blueprint_install", to: "blueprint_installs#new", as: :new_blueprint_install
  post "installs/blueprint_install", to: "blueprint_installs#create", as: :create_blueprint_install
  get "/installs/docker_hub_install_attach_service", to: "docker_hub_installs#new_attached_service", as: :docker_hub_install_attach_service
  get "/services/delete_orphaned_attached_service", to: "services#delete_orphaned_attached_service", as: :delete_orphaned_attached_service
  get "/services/delete_all_orphaned_attached_services", to: "services#delete_all_orphaned_attached_services", as: :delete_all_orphaned_attached_services

  resources :installs do
    collection do
      get :blueprint
      # get :progress
      get :installing
    end
  end

  resources :settings
  resources :galleries
  resources :backup_tasks
  resources :users
  resources :domains
  resources :networks
  resources :resources
  resources :software_variables
  resources :displays
  resources :attached_services do
    collection do 
      get(:registration)
    end
  end
  resources :attached_subservices

  resources :services do
    member do
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

  resources :softwares do
    collection do
      get :destroy_all_records
    end
    member do
      get(
        :start, :stop, :pause, :unpause, :restart,
        :create_container, :destroy_container,
        :uninstall, :reinstall, :delete_image,
        :build, :recreate, :advanced_detail)
    end
    member do
      patch(:uninstall_engine)
    end
  end

end
