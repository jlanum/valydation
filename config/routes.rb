HiStrollers::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :sales do 
    resources :purchases
  end

  resources :faves
  resources :users
  resources :comments
  resources :devices
  resources :cities
  resources :profile_photos
  resources :followers
  resources :search_results
  resources :sessions
  resources :merchants

  match '/mine' => 'sales#index',
    :defaults => {:my_feed => true}, :as => "my_faves"

  match '/users/:user_id/following' => 'followers#index',
          :defaults => {:im_following => true}, :as => "users_im_following"
  match '/users/:user_id/followers' => 'followers#index',
          :defaults => {:following_me => true}, :as => "users_following_me"

  match '/purchase_confirmation' => 'purchases#confirmation',
    :as => 'purchase_confirmation'

  match '/purchase_available' => 'purchases#available'

  match 'admin' => 'admin/sales#index'
  namespace :admin do
    resources :sales
    resources :users
    resources :leads
    resources :pages
  end

  match 'store_lookup' => 'sales#store_lookup'

  match 'logout' => 'sessions#destroy'
  match 'register' => 'users#register'
  match 'register_lead' => 'admin/leads#create'

  root :to => "users#landing"

  match '/contact' => 'pages#contact', :as => :contact
  match '/page/:slug' => 'pages#show', :as => :page
  match '/:custom_slug' => 'users#show', :as => :custom_slug
  
  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
