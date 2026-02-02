Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :timeslots, only: [ :index, :create, :destroy ]
  resources :users, only: [ :new, :create ]

  get "/admin", to: "admin#index"
  get "admin/reservations"
  get "admin/timeslots"
  get "admin/tables"

  get "/home", to: "home#index"
  get "home/reserve"
  post "home/confirm", to: "home#confirm", as: "home_confirm"

  get "home/reservations", to: "home#reservations", as: "home_reservations"
  delete "home/reservations/:id", to: "home#cancel_reservation", as: "home_cancel_reservation"

  root "startup#index"














  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
