Rails.application.routes.draw do

  devise_for :users, :skip => :registrations

  mount RailsAdmin::Engine => '/admin', as: :rails_admin

# get 'messaging' => 'app_installs#send_message'
get "installing/:id", to: "app_installs#installing"

  root to: redirect("/control_panel")

  get "control_panel", to: "pages#control_panel"
  get "help", to: "pages#help"
  get "system", to: "pages#system"
  get "installer", to: "pages#installer"
  get "install_progress/:line", to: "app_installs#install_progress"
  # get "settings", to: "settings#index"
  get "settings/edit_default_domain", to: "settings#edit_default_domain"
  get "settings/edit_default_website", to: "settings#edit_default_website"
  get "settings/edit_mail", to: "settings#edit_mail"
  get "settings/edit_wallpaper", to: "settings#edit_wallpaper"

  resources :settings
  resources :galleries
  resources :backup_tasks
  resources :users
  resources :domains

  get "domains/:id/new_ssl_certificate", to: "domains#new_ssl_certificate", as: :new_domain_ssl_certificate
  patch "domains/:id/create_ssl_certificate", to: "domains#create_ssl_certificate", as: :create_domain_ssl_certificate

  
  resources :services do
    get :advanced_detail, on: :member
    get :pause, on: :member
    get :unpause, on: :member
    get :start, on: :member
    get :stop, on: :member
    get :restart, on: :member
    get :show, on: :member
    get :recreate, on: :member
    get :create_container, on: :member
    get :register_website, on: :member
    get :deregister_website, on: :member     
    get :register_dns, on: :member
    get :deregister_dns, on: :member
  end


  # resources :softwares


  resources :softwares do
    collection do
      get :destroy_all_records
    end
    member do
      #get :edit_display_properties #, as: :edit_app_install_display_properties
      get(
        :start, :stop, :pause, :unpause, :restart,
        :delete_image, :create_container, :destroy_container,
        :build, :show, :recreate, :monitor, :demonitor,
        :advanced_detail,
        :register_website, :deregister_website,
        :register_dns, :deregister_dns,
        :edit_display_properties, :edit_network_properties, :edit_runtime_properties)
      patch(
        :update_display_properties, :update_network_properties, :update_runtime_properties)
    end
  end

end
