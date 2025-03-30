# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'v1/restaurants#index'

  get '/unauthorized', to: 'unauthorized#show'

  namespace :v1 do
    resources :restaurants do
      get 'reservations/by_hash/:hash_id', to: 'reservations#show_by_hash_at_restaurant', as: 'reservation_by_hash'
      resources :guests do
        resources :reservations
        get 'reservations/by_hash/:hash_id', to: 'reservations#show_by_hash', as: 'reservation_by_hash'
      end
    end
  end
end
