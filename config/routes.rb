Nouscourse::Application.routes.draw do
  root to: 'index#index'

  match '/signin',		to: 'sessions#new',         	via: 'get'
  match '/signout',		to: 'sessions#destroy',     	via: 'delete'

  match 'course/:course_name', to: 'index#index', as: :course_name, :constraints => { :course_name => /[^\/]+/ },  via: [:get]

  resources :users

  resources :courses, only: [:index, :new, :edit, :update, :create, :destroy, :destroy_all]
  resources :courses do
    delete '', on: :collection, action: 'destroy_all'
    resources :lessons do
      delete '', on: :collection, action: 'destroy_all'
    end
  end

  resources :lessons do
    resources :timetables, only: [:new, :create]
    resources :attachments, only: [:new, :create] do
      get :show_lesson_details
    end
  end

  resources :timetables, only: [:destroy]
  resources :attachments, only: [:destroy]

  resources :sessions, only: [:new, :create, :destroy]
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
