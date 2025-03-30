# Restaurant Reservation API

## Authentication Routes

| Method | URI Pattern | Controller Action | Description |
|--------|-------------|------------------|-------------|
| GET    | /users/sign_in | devise/sessions#new | Display sign in form |
| POST   | /users/sign_in | devise/sessions#create | Sign in |
| DELETE | /users/sign_out | devise/sessions#destroy | Sign out |
| GET    | /users/password/new | devise/passwords#new | New password form |
| GET    | /users/password/edit | devise/passwords#edit | Edit password form |
| PATCH/PUT | /users/password | devise/passwords#update | Update password |
| POST   | /users/password | devise/passwords#create | Create password |
| GET    | /users/sign_up | devise/registrations#new | Sign up form |
| POST   | /users | devise/registrations#create | Register new user |
| GET    | /users/edit | devise/registrations#edit | Edit profile form |
| PATCH/PUT | /users | devise/registrations#update | Update profile |
| DELETE | /users | devise/registrations#destroy | Delete account |

## Core API Routes (V1)

### Restaurant Endpoints

| Method | URI Pattern | Controller Action | Description |
|--------|-------------|------------------|-------------|
| GET    | /v1/restaurants | v1/restaurants#index | List all restaurants |
| POST   | /v1/restaurants | v1/restaurants#create | Create restaurant |
| GET    | /v1/restaurants/:id | v1/restaurants#show | Show restaurant details |
| PATCH/PUT | /v1/restaurants/:id | v1/restaurants#update | Update restaurant |
| DELETE | /v1/restaurants/:id | v1/restaurants#destroy | Delete restaurant |

### Guest Endpoints

| Method | URI Pattern | Controller Action | Description |
|--------|-------------|------------------|-------------|
| GET    | /v1/restaurants/:restaurant_id/guests | v1/guests#index | List restaurant guests |
| POST   | /v1/restaurants/:restaurant_id/guests | v1/guests#create | Create guest |
| GET    | /v1/restaurants/:restaurant_id/guests/:id | v1/guests#show | Show guest details |
| PATCH/PUT | /v1/restaurants/:restaurant_id/guests/:id | v1/guests#update | Update guest |
| DELETE | /v1/restaurants/:restaurant_id/guests/:id | v1/guests#destroy | Delete guest |

### Reservation Endpoints

| Method | URI Pattern | Controller Action | Description |
|--------|-------------|------------------|-------------|
| GET    | /v1/restaurants/:restaurant_id/guests/:guest_id/reservations | v1/reservations#index | List reservations |
| POST   | /v1/restaurants/:restaurant_id/guests/:guest_id/reservations | v1/reservations#create | Create reservation |
| GET    | /v1/restaurants/:restaurant_id/guests/:guest_id/reservations/:id | v1/reservations#show | Show reservation details |
| PATCH/PUT | /v1/restaurants/:restaurant_id/guests/:guest_id/reservations/:id | v1/reservations#update | Update reservation |
| DELETE | /v1/restaurants/:restaurant_id/guests/:guest_id/reservations/:id | v1/reservations#destroy | Delete reservation |

## Other Routes

| Method | URI Pattern | Controller Action | Description |
|--------|-------------|------------------|-------------|
| GET    | / | v1/restaurants#index | Root path (restaurants list) |
| GET    | /unauthorized | unauthorized#show | Unauthorized access page |

## Active Storage Routes

| Method | URI Pattern | Controller Action | Description |
|--------|-------------|------------------|-------------|
| GET    | /rails/active_storage/blobs/:signed_id/*filename | active_storage/blobs#show | Get file |
| GET    | /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename | active_storage/representations#show | Get transformed file |
| GET    | /rails/active_storage/disk/:encoded_key/*filename | active_storage/disk#show | Serve file from disk |
| PUT    | /rails/active_storage/disk/:encoded_token | active_storage/disk#update | Update file on disk |
| POST   | /rails/active_storage/direct_uploads | active_storage/direct_uploads#create | Direct upload |
``` 