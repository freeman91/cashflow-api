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

      # dashboard
      get "dashboard/data" => "dashboard#data"
      get "dashboard/expenses" => "dashboard#expenses"
      get "dashboard/incomes" => "dashboard#incomes"
      get "dashboard/work_hours" => "dashboard#work_hours"

      # week page
      get "week/data" => "week#data"

      # month page
      get "month/data" => "month#data"
      get "month/bills" => "month#bills"

      # year page
      get "year/data" => "year#data"

      # net worth page
      get "networth/data" => "networth#data"

      # settings page
      get "settings/data" => "settings#data"

      # expenses
      resources :expenses, only: [:create]
      put "expenses/update" => "expenses#update"
      get "expense_groups" => "expense_groups#data"
      delete "expenses" => "expenses#destroy"

      # incomes
      resources :incomes, only: [:create]
      put "incomes/update" => "incomes#update"
      get "income_sources" => "income_sources#data"
      delete "incomes" => "incomes#destroy"

      # work_hours
      resources :work_hours, only: [:create]
      put "work_hours/update" => "work_hours#update"
      delete "work_hours" => "work_hours#destroy"

      # properties
      resource :properties, only: [:create]
      put "properties/update" => "properties#update"
      delete "properties" => "properties#destroy"
      get "property_sources" => "property_sources#all"
      post "properties/month" => "properties#month"

      # debts
      resource :debts, only: [:create]
      put "debts/update" => "debts#update"
      delete "debts" => "debts#destroy"
      get "debt_groups" => "debt_groups#all"
      post "debts/month" => "debts#month"
    end
  end

  get "users/confirm/:token", to: "users#confirm", as: "users_confirm"
  get "users/confirm_reset/:token", to: "users#confirm_reset",
                                    as: "users_confirm_reset"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
end
