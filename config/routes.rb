Rails.application.routes.draw do
  devise_for :users #, :skip => :registrations

  root "pages#home"
  get "app_manager", to: "pages#app_manager", as: :app_manager
  get "help", to: "pages#help", as: :help
  get "system", to: "pages#system", as: :system
  get "installer", to: "app_installs#installer", as: :installer

  get "settings", to: "pages#settings", as: :settings
  get "edit_default_domain", to: "system_configs#edit_default_domain", as: :edit_default_domain
  get "edit_default_website", to: "system_configs#edit_default_website", as: :edit_default_website
  get "edit_mail", to: "system_configs#edit_mail", as: :edit_mail
  get "edit_wallpaper", to: "system_configs#edit_wallpaper", as: :edit_wallpaper
  resources :system_configs
  # post "settings/update", to: "settings_configs#update"
  # patch "settings/update", to: "settings_configs#update", as: :update_settings
  # get "settings", to: "settings_configs#settings", as: :settings

  resources :gallery_installs
  resources :app_installs
  # post "galleries/create", to: "galleries#create", as: :create_gallery
  # resources :galleries, only: [:index, :create, :destroy]
  # # post "installs/create", to: "installs#create", as: :installs_controller_install_forms
  # resources :installs

  # get "backup", to: "backup_tasks#index", as: :backup
  #post "backup_tasks/create_backup_task_for_db/:id", to: "backup_tasks#create_backup_task_for_db", as: :create_backup_task_for_db
  #post "backup_tasks/create_backup_task_for_fs/:id", to: "backup_tasks#create_backup_task_for_fs", as: :create_backup_task_for_fs
  resources :backup_tasks

  # get "users", to: "users#index", as: :users
  resources :users
  
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
  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
