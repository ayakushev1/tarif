Rails.application.routes.draw do
  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
  match "/422" => "errors#error422", via: [ :get, :post, :patch, :delete ]
  match "/500" => "errors#error500", via: [ :get, :post, :patch, :delete ]
  
  devise_for :users, 
    controllers: { sessions: "users/sessions", registrations: "users/registrations", confirmations: "users/confirmations"},
    path_names: { sign_in: 'login', sign_out: 'logout'}

  devise_scope :user do
    patch "/confirm" => "confirmations#confirm"

    get "login" => "users/sessions#new"
    post "submit_login" => "users/sessions#create"
    get "logout" => "users/sessions#destroy"

  end

  root 'home#index'
  resources :users
  resources :tarif_classes

  controller :home do
    get 'home/change_locale', action: :change_locale, as: :change_locale
#    get 'home/introduction', action: :introduction, as: :introduction
    get 'home/short_description' => :short_description
    get 'home/detailed_description' => :detailed_description
    get 'home/update_tabs' => :update_tabs
    get 'home/news' => :news
    
  end

  namespace :content do
    controller :articles do
      get 'articles/show' => :show
      get 'articles/index' => :index
      get 'articles/call_statistic' => :call_statistic
      get 'articles/detailed_results' => :detailed_results
    end
  end
  
  namespace :comparison do
    resources :optimizations
    controller :optimizations do
      get 'optimizations/calculate_optimizations/:id', action: :calculate_optimizations, as: :calculate_optimizations
      get 'optimizations/update_comparison_results/:id', action: :update_comparison_results, as: :update_comparison_results
      get 'optimizations/generate_calls_for_optimization/:id', action: :generate_calls_for_optimization, as: :generate_calls_for_optimization
      get 'optimizations/calculation_status/:id', action: :calculation_status, as: :calculation_status
    end
  end

  namespace :result do
    resources :runs

    controller :service_sets do
      get 'service_sets/results' => :results
      get 'service_sets/results/:result_run_id' => :result
      get 'service_sets/detailed_results' => :detailed_results
      get 'service_sets/compare/:result_run_id', action: :compare, as: :compare
      get 'service_sets/test' => :test
    end
  end
  
  namespace :tarif_optimizators do
    controller :main do
      get 'main/index' => :index
      get 'main/recalculate' => :recalculate
    end   

    controller :fixed_operators do
      get 'fixed_operators/index' => :index
      get 'fixed_operators/recalculate' => :recalculate
    end   

    controller :fixed_services do
      get 'fixed_services/index' => :index
      get 'fixed_services/recalculate' => :recalculate
    end   

    controller :limited_scope do
      get 'limited_scope/index' => :index
      get 'limited_scope/recalculate' => :recalculate
    end   

    controller :all_options do
      get 'all_options/index' => :index
      get 'all_options/recalculate' => :recalculate
    end   

    controller :admin do
      get 'admin/index' => :index
      get 'admin/recalculate' => :recalculate
      get 'admin/calculation_status' => :calculation_status
      get 'admin/select_services' => :select_services
    end   

  end
  
  namespace :customer do
    resources :demands, only: [:index, :new, :create]    

#    controller :optimization_steps do      
#      get 'optimization_steps/choose_load_calls_options' => :choose_load_calls_options
#      get 'optimization_steps/check_loaded_calls' => :check_loaded_calls
#      get 'optimization_steps/choose_optimization_options' => :choose_optimization_options
#      get 'optimization_steps/optimize_tarifs' => :optimize_tarifs
#      get 'optimization_steps/show_optimized_tarifs' => :show_optimized_tarifs
#    end
    controller :optimization_results do
      get 'optimization_results/show_results' => :show_results
      get 'optimization_results/show_customer_results' => :show_customer_results
      get 'optimization_results/show_additional_info' => :show_additional_info
      get 'optimization_results/show_customer_detailed_results' => :show_customer_detailed_results
      get 'optimization_results/test' => :test
    end
    
    controller :optimization_result_movers do
      post 'optimization_result_movers/move' => :move
      get 'optimization_result_movers/new' => :new
    end
    
    resources :services, only: [:index] do
      get 'calculate_statistic', on: :collection
    end   
    
    resources :call_runs
    controller :call_runs do
      get 'call_runs/call_stat/:id', action: :call_stat, as: :call_stat
      get 'call_runs/calculate_call_stat/:id', action: :calculate_call_stat, as: :calculate_call_stat
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
    
  
#  resources :tarif_lists, :price_lists  
#  resources :parameters, only: :index
#  resources :categories, only: :index
  

#  controller :sessions do
#    get 'login' => :new
#    post 'submit_login' => :create
#    get 'logout' => :destroy
#    get 'new_location' => :new_location
#    get 'set_new_location' => :choose_location
#  end

#for testing
#  get "formable_concerns/", :controller => 'formable_concerns', :action => :new, :as => "formable_concerns/new"     

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
