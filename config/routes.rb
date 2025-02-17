Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # CRUD Routes
  resources :admins
  resources :users do
    member do
      patch :change_password
    end
    collection do
      patch :do_transaction
    end
  end
  resources :loans
  resources :repayments
  resources :transactions

  # Authentication Route
  post "auth/admin-login", to: "authenticate#admin_login"
  post "auth/user-login", to: "authenticate#user_login"

  # OTP Route
  post "user/send-otp", to: "otp#send_otp"
  post "user/verify-otp", to: "passwords#verify_otp"
  patch "user/reset-password", to: "passwords#reset_password"
end
