Rails.application.routes.draw do

  devise_for :users, :skip => :registrations

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'



# get 'messaging' => 'app_installs#send_message'
get "installing/:id", to: "app_installs#installing", as: :installing


get "app_installs/:id/edit_display_properties", to: "app_installs#edit_display_properties", as: :edit_app_install_display_properties
get "app_installs/:id/edit_network_properties", to: "app_installs#edit_network_properties", as: :edit_app_install_network_properties
get "app_installs/:id/edit_runtime_properties", to: "app_installs#edit_runtime_properties", as: :edit_app_install_runtime_properties
patch "app_installs/:id/update_display_properties", to: "app_installs#update_display_properties", as: :update_app_install_display_properties
patch "app_installs/:id/update_network_properties", to: "app_installs#update_network_properties", as: :update_app_install_network_properties
patch "app_installs/:id/update_runtime_properties", to: "app_installs#update_runtime_properties", as: :update_app_install_runtime_properties

get "app_installs/destroy_all_records", to: "app_installs#destroy_all_records", as: :app_install_destroy_all_records

  root "pages#home"

  get "app_manager", to: "pages#app_manager", as: :app_manager
  get "help", to: "pages#help", as: :help
  get "system", to: "pages#system", as: :system
  get "installer", to: "pages#installer", as: :installer
  get "install_progress/:line", to: "app_installs#install_progress", as: :install_progress
  get "settings", to: "pages#settings", as: :settings
  # get "manage_domains", to: "system_configs#hosted_domains", as: :hosted_domains
  get "edit_default_domain", to: "system_configs#edit_default_domain", as: :edit_default_domain
  get "edit_default_website", to: "system_configs#edit_default_website", as: :edit_default_website
  get "edit_mail", to: "system_configs#edit_mail", as: :edit_mail
  get "edit_wallpaper", to: "system_configs#edit_wallpaper", as: :edit_wallpaper

  resources :system_configs
  resources :gallery_installs
  resources :backup_tasks
  resources :users
  resources :hosted_domains

get "hosted_domains/:id/new_ssl_certificate", to: "hosted_domains#new_ssl_certificate", as: :new_hosted_domain_ssl_certificate
patch "hosted_domains/:id/create_ssl_certificate", to: "hosted_domains#create_ssl_certificate", as: :create_hosted_domain_ssl_certificate

  resources :app_installs
  
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

  resources :apps do
    get :advanced_detail, on: :member
    get :pause, on: :member
    get :unpause, on: :member
    get :start, on: :member
    get :stop, on: :member
    get :delete_image, on: :member
    get :restart, on: :member
    get :destroy_container, on: :member
    get :create_container, on: :member
    get :build, on: :member
    get :show, on: :member
    get :recreate, on: :member
    get :monitor, on: :member
    get :demonitor, on: :member
    get :register_website, on: :member
    get :deregister_website, on: :member
    get :register_dns, on: :member
    get :deregister_dns, on: :member  
  end

end
