# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/v1/api-docs'
  mount Rswag::Api::Engine => '/v1/api-docs'
  devise_for :users, path: '', path_names: {
    sign_in: 'users/sign_in',
    sign_out: 'users/sign_out',
    registration: 'users'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    # passwords: 'users/passwords' # Add if you customize password controllers
  }

  root to: 'v1/restaurants#index'

  get '/unauthorized', to: 'unauthorized#show'

  namespace :v1 do
    get 'reservations/pending_confirmations', to: 'reservations#pending_confirmations'
    
    resources :restaurants do
      resources :reservations, only: %i[index show create update destroy] do
        member do
          post :request_confirmation
        end
        collection do
          get 'by_hash/:hash_id', to: 'reservations#show_by_hash_at_restaurant', as: 'reservation_by_hash'
        end
      end
      resources :guests do
        resources :reservations, only: %i[index show create update destroy] do
          member do
            post :request_confirmation
          end
          collection do
            get 'by_hash/:hash_id', to: 'reservations#show_by_hash', as: 'reservation_by_hash'
          end
        end
        collection do
          post :search
        end
      end
      resources :tables, only: %i[index show create update destroy]
      resources :sections, only: %i[index show create update destroy]
    end

    get 'public/restaurants/:restaurant_id/reservations/by_hash/:hash_id', to: 'public_reservations#show_by_hash', as: 'public_reservation_by_hash'

    get '/unauthorized', to: 'application#unauthorized', as: :unauthorized
  end
end
