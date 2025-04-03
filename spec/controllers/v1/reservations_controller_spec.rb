# frozen_string_literal: true

require 'rails_helper'

describe V1::ReservationsController do
  before(:each) do
    set_auth_headers
  end

  it 'returns a reservation' do
    restaurant = create(:restaurant, :with_guest_and_reservation)
    guest = restaurant.guests.first
    reservation = restaurant.reservations.first
    get :show, params: { restaurant_id: restaurant.id, guest_id: guest.id, id: reservation.id }
    expect(json['status']).to eq(reservation.status)
  end

  it 'updates a reservation' do
    restaurant = create(:restaurant, :with_guest_and_reservation)
    guest = restaurant.guests.first
    reservation = restaurant.reservations.first
    put :update, params: { restaurant_id: restaurant.id, guest_id: guest.id, id: reservation.id, "reservation": {
      "covers": '10'
    } }
    expect(json['covers']).to eq(10)
  end

  it 'creates a reservation' do
    restaurant = create(:restaurant, :with_guest)
    guest = restaurant.guests.first
    post :create, params: { restaurant_id: restaurant.id, guest_id: guest.id, "reservation": {
      "status": 'pending',
      "start_time": '1576578362',
      "covers": '2',
      "notes": "I'm a cartoon character so I can't eat real food"
    } }
    expect(json['status']).to eq('pending')
    expect(json['start_time']).to eq('2019-12-17T10:26:02.000Z')
    expect(json['covers']).to eq(2)
    expect(json['notes']).to eq("I'm a cartoon character so I can't eat real food")
  end

  it 'deletes a reservation' do
    restaurant = create(:restaurant, :with_guest_and_reservation)
    guest = restaurant.guests.first
    reservation = restaurant.reservations.first
    restaurant = create(:restaurant)
    delete :destroy, params: { restaurant_id: restaurant.id, guest_id: guest.id, id: reservation.id }
    expect(Reservation.count).to eq(0)
  end

  it 'returns reservation details by hash_id' do
    restaurant = create(:restaurant, :with_guest_and_reservation)
    guest = restaurant.guests.first
    reservation = restaurant.reservations.first
    
    # Ensure the reservation has a hash_id
    hash_id = "010425_AbCdE"
    reservation.update(hash_id: hash_id)
    
    get :show_by_hash, params: { restaurant_id: restaurant.id, guest_id: guest.id, hash_id: hash_id }
    
    expect(response).to have_http_status(:success)
    expect(json['reservation']['id']).to eq(reservation.id)
    expect(json['guest']['id']).to eq(guest.id)
    expect(json['recent_reservations_count']).to be_a(Integer)
  end
  
  it 'returns reservation details by hash_id at restaurant level' do
    restaurant = create(:restaurant, :with_guest_and_reservation)
    guest = restaurant.guests.first
    reservation = restaurant.reservations.first
    
    # Ensure the reservation has a hash_id
    hash_id = "010425_XyZaB"
    reservation.update(hash_id: hash_id)
    
    get :show_by_hash_at_restaurant, params: { restaurant_id: restaurant.id, hash_id: hash_id }
    
    expect(response).to have_http_status(:success)
    expect(json['reservation']['id']).to eq(reservation.id)
    expect(json['guest']['id']).to eq(guest.id)
    expect(json['recent_reservations_count']).to be_a(Integer)
  end

  describe 'POST #request_confirmation' do
    context 'when user is authorized' do
      let(:reservation) { create(:reservation, restaurant: restaurant, guest: guest, confirmation_request: false) }
      
      before do
        sign_in user
      end
      
      it 'sets confirmation_request to true' do
        post :request_confirmation, params: { restaurant_id: restaurant.id, id: reservation.id }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['reservation']['confirmation_request']).to eq(true)
        expect(JSON.parse(response.body)['message']).to eq('Confirmation request sent successfully')
        
        # Reload the reservation to verify the database was updated
        reservation.reload
        expect(reservation.confirmation_request).to eq(true)
        expect(reservation.confirmation_request_date).not_to be_nil
      end
    end
    
    context 'when user is not authorized' do
      let(:reservation) { create(:reservation, restaurant: restaurant, guest: guest) }
      let(:another_user) { create(:user) }
      
      before do
        sign_in another_user
      end
      
      it 'returns unauthorized' do
        post :request_confirmation, params: { restaurant_id: restaurant.id, id: reservation.id }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
