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
  resources :comments
  resources :devices
  resources :cities
  resources :profile_photos
  resources :followers
  resources :search_results
  resources :sessions
  resources :merchants
  resources :activities
  resources :users 

  match 'add_to_cart' => 'purchases#add_to_cart', :as => 'add_to_cart'
  match 'clear_cart' => 'purchases#clear_cart', :as => 'clear_cart'
  match 'remove_from_cart/:sale_id' => 'purchases#remove_from_cart', :as => 'remove_from_cart'
  match 'view_cart' => 'purchases#view_cart', :as => 'view_cart'
  match '/purchases/add_to_cart' => 'purchases#add_to_cart', :as => 'add_to_cart'

  match '/stores/list' => "users#stores"

  match '/mine' => 'sales#index',
    :defaults => {:my_feed => true}, :as => "my_faves"

  match '/users/:user_id/following' => 'followers#index',
          :defaults => {:im_following => true}, :as => "users_im_following"
  match '/users/:user_id/followers' => 'followers#index',
          :defaults => {:following_me => true}, :as => "users_following_me"
 
  resources :purchases do
    get 'sold', :on => :collection
  end
  match '/purchase_confirmation' => 'purchases#confirmation',
    :as => 'purchase_confirmation'
    match '/purchase_new' => 'purchases#new',
      :as => 'purchase_new'
  match '/purchase_available' => 'purchases#available'
  match 'admin' => 'admin/sales#index'
  match 'new_sale_purchase' => 'purchases#new', :as => 'new_sale_purchase'
  namespace :admin do
    resources :users do
      get 'export', :on => :collection
    end
    resources :sales do
      resources :sale_images
    end
    resources :sale_groups
    resources :leads
    resources :pages
    resources :purchases
  end

  match 'store_lookup' => 'sales#store_lookup'

  match 'logout' => 'sessions#destroy'
  match 'register' => 'users#register'
  match 'register_lead' => 'admin/leads#create'
  match 'forgot_passwd' => 'users#forgot_passwd'

  root :to => "pages#show", :defaults => {:slug => "curated-landing"}

  match '/featured/:slug' => "sales#group", :as => :group_slug

  match '/stores' => "pages#show", :defaults => {:slug => "merchants-intro"}, :as => :stores_page
  match '/contact' => 'pages#contact', :as => :contact
  match '/consignment' => 'pages#consignment', :as => :consignment
  match '/page/:slug.css' => 'pages#css'
  match '/page/:slug' => 'pages#show', :as => :page

  match "/404", :to => "errors#not_found"

  ##IMPORTANT!!! THIS ALWAYS GOTTA GO LAST OR USERS MIGHT BREAK ROUTES WITH CUSTOM SLUGS!!
  match '/static/landing2.html' => "users#landing"
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
