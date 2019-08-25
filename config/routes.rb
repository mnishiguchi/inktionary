# frozen_string_literal: true

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resource :session, only: %i[create destroy]
  resources :tags, only: %i[index show]
  resource :user, only: :show
  resources :words, only: %i[index show new create update destroy] do
    resource :vote, only: :update, module: :words
    resources :tags, only: %i[create destroy], module: :words
  end

  root to: "words#index"
end
