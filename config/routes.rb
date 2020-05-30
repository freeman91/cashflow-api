require "api_constraints.rb"

Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # Api definition
  scope module: :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1,
                                                       default: true) do
      get "versions/state" => "versions#state"
      post "sessions" => "sessions#create"
      delete "sessions" => "sessions#destroy"
      post "users/reset_password" => "users#reset_password"
      resources :users, only: [:create, :destroy]
      resources :expenses

      get "dashboard/data" => "dashboard#data"
    end
  end

  get "users/confirm/:token", to: "users#confirm", as: "users_confirm"
  get "users/confirm_reset/:token", to: "users#confirm_reset",
                                    as: "users_confirm_reset"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
end
