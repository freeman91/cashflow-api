# frozen_string_literal: true

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
      get "sessions" => "sessions#valid_token"
      post "users/reset_password" => "users#reset_password"
      resources :users, only: %i[create destroy]

      # dashboard
      get "dashboard/expense_sum" => "dashboard#expense_sum"
      get "dashboard/income_sum" => "dashboard#income_sum"
      get "dashboard/work_hour_sum" => "dashboard#work_hour_sum"
      get "dashboard/expenses" => "dashboard#expenses"
      get "dashboard/incomes" => "dashboard#incomes"
      get "dashboard/work_hours" => "dashboard#work_hours"

      # month page
      get "month/pie-chart" => "month#pie_chart"

      # year page
      get "year/data" => "year#data"

      # net worth page
      get "networth/data" => "networth#data"
      get "networth/properties" => "networth#properties"
      get "networth/debts" => "networth#debts"

      # expenses
      resources :expenses, only: [:create]
      get "expenses/month" => "expenses#month"
      put "expenses/update" => "expenses#update"
      delete "expenses" => "expenses#destroy"

      # incomes
      resources :incomes, only: [:create]
      get "incomes/month" => "incomes#month"
      put "incomes/update" => "incomes#update"
      delete "incomes" => "incomes#destroy"

      # work_hours
      resources :work_hours, only: [:create]
      get "work_hours/month" => "work_hours#month"
      put "work_hours/update" => "work_hours#update"
      delete "work_hours" => "work_hours#destroy"

      # debts
      resource :debts, only: [:create]
      put "debts/update" => "debts#update"
      delete "debts" => "debts#destroy"
      get "debt_groups" => "debt_groups#data"
      post "debts/month" => "debts#month"

      # properties
      resource :properties, only: [:create]
      put "properties/update" => "properties#update"
      delete "properties" => "properties#destroy"
      get "property_sources" => "property_sources#data"
      post "properties/month" => "properties#month"

      # expense groups
      resource :expense_groups, only: [:create]
      get "expense_groups/all" => "expense_groups#all"
      get "expense_groups" => "expense_groups#data"
      post "expense_groups/update" => "expense_groups#update"
      delete "expense_groups" => "expense_groups#destroy"

      # income sources
      resource :income_sources, only: [:create]
      get "income_sources/all" => "income_sources#all"
      get "income_sources" => "income_sources#data"
      post "income_sources/update" => "income_sources#update"
      delete "income_sources" => "income_sources#destroy"

      # debt groups
      resource :debt_groups, only: [:create]
      get "debt_groups/all" => "debt_groups#all"
      get "debt_groups" => "debt_groups#data"
      post "debt_groups/update" => "debt_groups#update"
      delete "debt_groups" => "debt_groups#destroy"

      # property sources
      resource :property_sources, only: [:create]
      get "property_sources/all" => "property_sources#all"
      get "property_sources" => "property_sources#data"
      post "property_sources/update" => "property_sources#update"
      delete "property_sources" => "property_sources#destroy"
    end
  end

  get "users/confirm/:token", to: "users#confirm", as: "users_confirm"
  get "users/confirm_reset/:token", to: "users#confirm_reset",
                                    as: "users_confirm_reset"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
end
