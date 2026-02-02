Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :timeslots, only: [ :index, :create, :destroy ]
  resources :users, only: [ :new, :create ]

  get "/admin", to: "admin#index"

  get "admin/reservations", to: "admin#reservations", as: "admin_reservations"
  get "admin/reservations/:id", to: "admin#show_reservation", as: "admin_show_reservation"
  patch "admin/reservations/:id", to: "admin#update_reservation", as: "admin_update_reservation"
  delete "admin/reservations/:id", to: "admin#cancel_reservation", as: "admin_cancel_reservation"

  get "admin/timeslots", to: "admin#timeslots", as: "admin_timeslots"
  get    "admin/timeslots/:id", to: "admin#show_timeslot",   as: "admin_show_timeslot"
  post   "admin/timeslots",     to: "admin#create_timeslot", as: "admin_create_timeslot"
  patch  "admin/timeslots/:id", to: "admin#update_timeslot", as: "admin_update_timeslot"
  delete "admin/timeslots/:id", to: "admin#delete_timeslot", as: "admin_delete_timeslot"

  post   "admin/timeslots/:id/add_table", to: "admin#add_table_to_timeslot", as: "admin_add_table_to_timeslot"
  delete "admin/timeslots/:id/remove_table/:table_id",
        to: "admin#remove_table_from_timeslot",
        as: "admin_remove_table_from_timeslot"



  get "admin/tables", to: "admin#tables", as: "admin_tables"



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
