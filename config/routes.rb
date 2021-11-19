Rails.application.routes.draw do
  get 'users/register'

  get 'home/contact'

  get 'home/medications'

  get 'home/about'

  get 'home/index'

  post 'home/send_contact_message'

  post 'medications/set_page_count'

  post 'medications/search_meds'

  post 'events/set_page_count'

  post 'events/search_events'

  get 'events/past_events'

  post 'events/set_past_page_count'

  post 'events/search_past_events'

  get 'events/complete'

  get 'events/incomplete'

  post 'events/change_notes'

  post 'users/register_district_admin'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root "home#index"
  resources :users
  resources :students
  resources :parents
  resources :admins
  resources :nurses
  resources :districts
  resources :medications
  resources :events
  resources :inventories
  resources :forms


  match '/login', to: 'sessions#new', via: :get
  match '/login_create', to: 'sessions#create', via: :post
  match '/logout', to: 'sessions#destroy', via: :delete
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
