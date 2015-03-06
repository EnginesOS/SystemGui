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
  # get "install_progress/:line", to: "softwares#install_progress"
  # get "settings", to: "settings#index"
  get "settings/edit_default_domain", to: "settings#edit_default_domain"
  get "settings/edit_default_website", to: "settings#edit_default_website"
  get "settings/edit_mail", to: "settings#edit_mail"
  get "settings/edit_wallpaper", to: "settings#edit_wallpaper"
  get "installer", to: "installs#installer"
  # get "engine_install", to: "installs#engine_install", as: :engine_install
  get "domains/:id/new_ssl_certificate", to: "domains#new_ssl_certificate", as: :new_domain_ssl_certificate
  patch "domains/:id/create_ssl_certificate", to: "domains#create_ssl_certificate", as: :create_domain_ssl_certificate

  resources :installs
  resources :settings
  resources :galleries
  resources :backup_tasks
  resources :users
  resources :domains
  resources :networks
  resources :resources
  resources :software_variables
  resources :displays
  resources :attached_services
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
        :register_website,
        :deregister_website,
        :register_dns,
        :deregister_dns,
        :manager)
    end
  end

  resources :softwares do
    collection do
      get :destroy_all_records
    end
    member do
      get(
        :new,
        :start, :stop, :pause, :unpause, :restart,
        :delete_image, :create_container, :destroy_container,
        :build, :show, :recreate, :monitor, :demonitor,
        :advanced_detail,
        :register_website, :deregister_website,
        :register_dns, :deregister_dns)
    end
  end

end
