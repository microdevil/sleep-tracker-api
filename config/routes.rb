Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :sleep_trackers

  get "/feeds", to: "feeds#index", as: :feeds

  post "/users/:user_id/follow", to: "follows#create", as: :follow_user
  delete "/users/:user_id/unfollow", to: "follows#destroy", as: :unfollow_user
end
