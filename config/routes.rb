Rails.application.routes.draw do

  resources :reports, only: [:index] do
    collection do
      get 'place_work_report'
    end
  end
  resources :description_diagnoses
  resources :complictations
  resources :class_diseases
  resources :diagnoses
  resources :positions
  resources :departments
  resources :doctors
  resources :patients
  resources :clinical_records
  resources :medical_policies
  resources :passports
  resources :place_works
  resources :addresses
  resources :sites
  resources :houses
  resources :streets
  resources :cities
  resources :people

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout'},
              controllers: {sign_up: 'registrations'}

  root :to => 'cabinets#index'
  resources :cabinets
   # get 'cabinets' => 'people#cabinet'
   # put 'select_role' => 'cabinets#select_role', as: :select_role, on: :collection


  # authenticated :user, lambda { |u| u.has_role? :admin } do
  #  # root :to => 'users#index', :as => :admin_root
  #  root :to => 'cabinets#index', :as => :admin_root
  # end
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
