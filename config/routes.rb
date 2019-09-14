# frozen_string_literal: true

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # API endpoints
  namespace :v1, defaults: { format: :json } do
    get :autocomplete, to: "autocomplete#index"
    get :contributors, to: "contributors#index"
    get :dictionary, to: "dictionary#index"
    get :popular_words, to: "popular_words#index"
    get :tags, to: "tags#index"

    # TODO: authorized user only
    resource :user, only: :show
    resources :words, only: %i[create update destroy]
    resource :word_vote, only: :update
    resources :word_tags, only: %i[index create]
    resource :word_tag, only: %i[destroy]
  end

  # Web app
  resource :session, only: %i[create destroy]
  resources :tags, only: %i[index show]
  resource :user, only: :show
  resources :words, only: %i[index show new create update destroy] do
    resource :vote, only: :update, module: :words
    resources :tags, only: %i[create destroy], module: :words
  end

  root to: "words#index"
end
