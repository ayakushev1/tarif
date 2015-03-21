Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }

  devise_scope :user do
    get "users/new" => "devise/registrations#new"
    post "users/create" => "devise/registrations#create"
    get "users/:id/edit" => "devise/registrations#edit"
    patch "users/:id" => "devise/registrations#update"
    put "users/:id" => "devise/registrations#update"
    delete "users/:id" => "devise/registrations#destroy"

#    get "users/sign_out" => "devise/sessions#destroy"
    
    get "login" => "users/sessions#new"
    post "submit_login" => "users/sessions#create"
    get "logout" => "users/sessions#destroy"

    get "demo/login" => "users/sessions#new"
    post "demo/submit_login" => "users/sessions#create"
    get "demo/logout" => "users/sessions#destroy"
  end

#  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
#  devise_for :users, path: "auth", path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
#  root 'home#index'
  root 'demo/home#index'

  namespace :content do
    controller :articles do
      get 'articles/show' => :show
      get 'articles/index' => :index
      get 'articles/call_statistic' => :call_statistic
      get 'articles/detailed_results' => :detailed_results
    end
  end
  
  namespace :demo do
    controller :home do
      get 'home/short_description' => :short_description
      get 'home/detailed_description' => :detailed_description
#      get 'home/demo_results' => :demo_results
    end

    controller :sessions do
      get 'login' => :new
      post 'submit_login' => :create
      get 'logout' => :destroy
    end
    
    controller :optimization_steps do      
      get 'optimization_steps/choose_load_calls_options' => :choose_load_calls_options
      get 'optimization_steps/check_loaded_calls' => :check_loaded_calls
      get 'optimization_steps/choose_optimization_options' => :choose_optimization_options
      get 'optimization_steps/optimize_tarifs' => :optimize_tarifs
      get 'optimization_steps/show_optimized_tarifs' => :show_optimized_tarifs
    end
    
    controller :calls do
      get 'calls/' => :index
      get 'calls/set_calls_generation_params' => :set_calls_generation_params
      get 'calls/set_default_calls_generation_params' => :set_default_calls_generation_params
      get 'calls/generate_calls' => :generate_calls
    end

    controller :history_parsers do
      get 'history_parsers/prepare_for_upload' => :prepare_for_upload
      post 'history_parsers/upload' => :upload
      get 'history_parsers/upload' => :upload
      get 'history_parsers/calculation_status' => :calculation_status
    end

    controller :tarif_optimizators do      
      get 'tarif_optimizators/index' => :index
      get 'tarif_optimizators/recalculate' => :recalculate
      get 'tarif_optimizators/calculation_status' => :calculation_status
      get 'tarif_optimizators/select_services' => :select_services
    end

    controller :optimization_results do
      get 'optimization_results/show_customer_results' => :show_customer_results
    end
    
  end  
=begin  
    controller :project_support do
      get 'project_support/donate' => :donate
    end
  end
=end  
  resources :tarif_lists, :price_lists
  
  namespace :customer do
    resources :demands, only: [:index, :new, :create]    

    controller :tarif_optimizators do
      get 'tarif_optimizators/index' => :index
      get 'tarif_optimizators/recalculate' => :recalculate
      get 'tarif_optimizators/calculation_status' => :calculation_status
      get 'tarif_optimizators/select_services' => :select_services
    end   

    controller :optimization_results do
      get 'optimization_results/show_results' => :show_results
      get 'optimization_results/show_customer_results' => :show_customer_results
      get 'optimization_results/show_additional_info' => :show_additional_info
    end
    
    controller :optimization_result_movers do
      post 'optimization_result_movers/move' => :move
      get 'optimization_result_movers/new' => :new
    end
    
    resources :services, only: [:index] do
      get 'calculate_statistic', on: :collection
    end   

    controller :calls do
      get 'calls/' => :index
      get 'calls/set_calls_generation_params' => :set_calls_generation_params
      get 'calls/set_default_calls_generation_params' => :set_default_calls_generation_params
      get 'calls/generate_calls' => :generate_calls
    end

    controller :history_parsers do
      get 'history_parsers/prepare_for_upload' => :prepare_for_upload
      post 'history_parsers/upload' => :upload
      get 'history_parsers/upload' => :upload
      get 'history_parsers/parse' => :parse
      get 'history_parsers/calculation_status' => :calculation_status
    end

    resource :payments
    
    controller :payments do
#      get 'payments/' => :new
#      post 'payments/' => :create
      get 'payments/wait_for_payment_being_processed' => :wait_for_payment_being_processed
      post 'payments/process_payment' => :process_payment
    end
  end

  namespace :price do
    resources :formulas, only: [:index]    
    resources :standard_formulas, only: [:index]    
  end

  namespace :service do
    resources :category_groups, only: [:index] 
    resources :categories, only: [:index] do
      resources :criteria, only: [:index]
    end
#    get 'categories/' => 'categories#index'    
  end
  

  resources :users, :tarif_classes

  controller :home1 do
    get 'home1/index' => :index
  end  


  resources :parameters, only: :index
  resources :categories, only: :index
  

  controller :sessions do
    get 'login' => :new
    post 'submit_login' => :create
    get 'logout' => :destroy
    get 'new_location' => :new_location
    get 'set_new_location' => :choose_location
  end

#for testing
  get "formable_concerns/", :controller => 'formable_concerns', :action => :new, :as => "formable_concerns/new"     

#  get "users/new_1", :controller => 'users', :action => :new, :as => "new/users" #for testing     

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
