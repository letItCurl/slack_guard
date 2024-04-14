Rails.application.routes.draw do
  get "home/index"
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

  scope module: :back_office do
    resources :campaigns, only: [ :new, :create, :show, :index ]
    resources :feedbacks, only: [ :new, :create ]
    resource :user, only: [ :update ]
  end

  devise_scope :user do
    authenticated do
      root to: "back_office/campaigns#index", as: :authenticated_root
    end

    unauthenticated do
      root to: "home#index", as: :unauthenticated_root
    end
  end
end
