Buttery::Application.routes.draw do

  resources :orders

  resources :users

  resources :makeups
  resources :users
  resources :parents
  resources :ingredients


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
   root :to => "public#show_menu"
   match 'about' => "about#index"
   match 'home' => "public#show_menu"
   match 'worker/update_inventory' => 'worker#update_inventory'
   match 'worker/manage_menu' => 'worker#add_items'
   match 'worker/add_ing_to_itm' => 'worker#add_ing_to_itm'
   match 'worker/update_ing_from_itm' => 'worker#update_ing_from_itm'
   match 'users_controls/activate_account/*username/*hash' => 'user_accounts#activation'
   match 'account' => 'account#main'
   match 'account_controller/new_pwd/*username/*hash' => 'account#new_pwd'
   match 'worker/orders' => 'order#view_order_queue'
   match 'worker/manual' => 'worker#manual'
   post 'worker/add_items'
   post 'worker/add_inv'
   post 'worker/sub_inv'
   post 'worker/empty_inv'
   post 'worker/restock'
   post 'worker/up_inv1'
   post 'worker/up_inv2'
   post 'user_accounts/signup'
   post 'user_accounts/login'
   post 'user_accounts/logout'
   post 'account/change_pwd'
   post 'account/reset_pwd'
   post 'account/cancel_order'
   post '/user_accounts/logout'
   post '/order/add_order'
   post '/order/refresh_queue'
   post 'order/view_order_queue'
   post 'order/add_manual_order'
   post 'account/main'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
