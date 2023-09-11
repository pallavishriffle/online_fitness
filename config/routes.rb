# frozen_string_literal: true

Rails.application.routes.draw do
  post 'user_login', to: 'users#user_login'
  resource :users do
    resources :programs
    resources :purchases
    resources :categories
  end
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'   
end
