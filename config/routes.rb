Rails.application.routes.draw do
  root 'home#index'
  
  resources :tarif_lists, :price_list, :price_standard_formulas
  
  namespace :price do
    resoures :price_formulas, only: [:index]    
  end

  namespace :service do
    resources :category_groups, only: [:index] 
    resources :categories, only: [:index] do
      resources :criteria, only: [:index]
    end
#    get 'categories/' => 'categories#index'    
  end
  
  resources :users, :tarif_classes
  
  resources :parameters, only: :index
  resources :categories, only: :index
  
  controller :calls do
    get 'calls/' => :index
    get 'calls/set_calls_generation_params' => :set_calls_generation_params
    get 'calls/set_default_calls_generation_params' => :set_default_calls_generation_params
    get 'calls/generate_calls' => :generate_calls
  end

  controller :sessions do
    get 'login' => :new
    get 'submit_login' => :create
    get 'logout' => :destroy
    get 'new_location' => :new_location
    get 'set_new_location' => :choose_location
  end

#for testing
  get "formable_concerns/", :controller => 'formable_concerns', :action => :new, :as => "formable_concerns/new"     
  get "users/new_1", :controller => 'users', :action => :new, :as => "new/users" #for testing     

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
