Rails.application.routes.draw do

  devise_for :users, :skip => :registrations

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root "pages#home"

  get "app_manager", to: "pages#app_manager", as: :app_manager
  get "help", to: "pages#help", as: :help
  get "system", to: "pages#system", as: :system
  get "installer", to: "pages#installer", as: :installer
  get "settings", to: "pages#settings", as: :settings
  get "edit_default_domain", to: "system_configs#edit_default_domain", as: :edit_default_domain
  get "edit_default_website", to: "system_configs#edit_default_website", as: :edit_default_website
  get "edit_mail", to: "system_configs#edit_mail", as: :edit_mail
  get "edit_wallpaper", to: "system_configs#edit_wallpaper", as: :edit_wallpaper

  resources :system_configs
  resources :gallery_installs
  resources :backup_tasks
  resources :users

  get "installing", to: "app_installs#installing", as: :installing
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
