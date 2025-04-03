# frozen_string_literal: true

require 'rails_helper'

describe Reservation do
  context 'when status is requested' do
    it 'returns true when requested? is called' do
      reservation = build(:reservation, :requested)
      expect(reservation.requested?).to eq(true)
    end
  end

  context 'when status is pending' do
    it 'returns true when pending? is called' do
      reservation = build(:reservation, :pending)
      expect(reservation.pending?).to eq(true)
    end
  end

  context 'when status is booked' do
    it 'returns true when booked? is called' do
      reservation = build(:reservation, :booked)
      expect(reservation.booked?).to eq(true)
    end
  end

  context 'when status is ended' do
    it 'returns true when ended? is called' do
      reservation = build(:reservation, :ended)
      expect(reservation.ended?).to eq(true)
    end
  end

  context 'when status is cancelled' do
    it 'returns true when cancelled? is called' do
      reservation = build(:reservation, :cancelled)
      expect(reservation.cancelled?).to eq(true)
    end
  end
  
  context 'when status is noshow' do
    it 'returns true when noshow? is called' do
      reservation = build(:reservation, :noshow)
      expect(reservation.noshow?).to eq(true)
    end
  end
  
  context 'when creating a reservation' do
    it 'generates a hash_id in the correct format' do
      reservation_date = DateTime.new(2025, 4, 15, 18, 30)
      restaurant = create(:restaurant)
      guest = create(:guest, restaurant: restaurant)
      reservation = create(:reservation, guest: guest, restaurant: restaurant, start_time: reservation_date)
      
      expect(reservation.hash_id).to be_present
      expect(reservation.hash_id).to match(/^\d{6}_[A-Za-z]{5}$/)
      
      date_part = reservation_date.strftime("%d%m%y")
      expect(reservation.hash_id).to start_with(date_part)
    end
    
    context 'with Facebook API integration' do
      let(:restaurant) { create(:restaurant, :with_channel_credentials) }
      let(:guest) { create(:guest, restaurant: restaurant) }
      
      before do
        # Stub the FacebookQrService
        allow_any_instance_of(FacebookQrService).to receive(:generate_qr_code).and_return({
          'code' => 'IJ5TLDV2DPTHL1',
          'prefilled_message' => '120325_A1234',
          'deep_link_url' => 'https://wa.me/message/IJ5TLDV2DPTHL1',
          'qr_image_url' => 'https://example.com/qr_image.svg'
        })
        
        allow_any_instance_of(FacebookQrService).to receive(:upload_qr_to_s3).and_return('https://s3-bucket.example.com/qr_image.svg')
      end
      
      it 'generates a QR code and uploads to S3' do
        reservation = create(:reservation, guest: guest, restaurant: restaurant)
        
        expect(reservation.qr_code_image).to eq('https://s3-bucket.example.com/qr_image.svg')
      end
    end
  end
  
  context 'when updating confirmation_request' do
    it 'sets confirmation_request_date when confirmation_request is set to true' do
      reservation = create(:reservation, confirmation_request: false)
      expect(reservation.confirmation_request_date).to be_nil
      
      freeze_time = Time.current
      allow(Time).to receive(:current).and_return(freeze_time)
      
      reservation.update(confirmation_request: true)
      expect(reservation.confirmation_request_date).to eq(freeze_time)
    end
    
    it 'does not update confirmation_request_date when confirmation_request is already true' do
      freeze_time = Time.current
      allow(Time).to receive(:current).and_return(freeze_time)
      
      reservation = create(:reservation, confirmation_request: true)
      expect(reservation.confirmation_request_date).to eq(freeze_time)
      
      # Advance time
      new_time = freeze_time + 1.day
      allow(Time).to receive(:current).and_return(new_time)
      
      reservation.update(notes: "Updated notes")
      expect(reservation.confirmation_request_date).to eq(freeze_time)
    end
  end
end
