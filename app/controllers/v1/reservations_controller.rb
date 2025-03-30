# frozen_string_literal: true

module V1
  class ReservationsController < ApplicationController
    before_action :set_reservation, except: %i[index create show_by_hash show_by_hash_at_restaurant]
    before_action :parse_start_time, only: %i[update create]

    authorize_resource

    def index
      guest = Guest.find(params[:guest_id])
      json_response(guest.reservations)
    end

    def show
      json_response(@reservation)
    end

    def show_by_hash
      restaurant = Restaurant.find(params[:restaurant_id])
      guest = Guest.find(params[:guest_id])
      
      begin
        reservation = Reservation.find_by!(hash_id: params[:hash_id], restaurant_id: restaurant.id, guest_id: guest.id)
        
        # Get guest's reservations from last 6 months based on created_at
        six_months_ago = DateTime.now - 6.months
        recent_reservations_count = guest.reservations.where('created_at > ?', six_months_ago).count
        
        response_data = {
          reservation: reservation,
          guest: guest.as_json(except: [:created_at, :updated_at]),
          recent_reservations_count: recent_reservations_count
        }
        
        json_response(response_data)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Reservation with hash_id '#{params[:hash_id]}' not found" }, status: :not_found
      end
    end

    def show_by_hash_at_restaurant
      restaurant = Restaurant.find(params[:restaurant_id])
      
      begin
        reservation = Reservation.find_by!(hash_id: params[:hash_id], restaurant_id: restaurant.id)
        guest = reservation.guest
        
        # Get guest's reservations from last 6 months based on created_at
        six_months_ago = DateTime.now - 6.months
        recent_reservations_count = guest.reservations.where('created_at > ?', six_months_ago).count
        
        response_data = {
          reservation: reservation,
          guest: guest.as_json(except: [:created_at, :updated_at]),
          recent_reservations_count: recent_reservations_count
        }
        
        json_response(response_data)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Reservation with hash_id '#{params[:hash_id]}' not found at this restaurant" }, status: :not_found
      end
    end

    def update
      @reservation.update(reservation_params)
      json_response(@reservation)
    end

    def create
      guest = Guest.find(params[:guest_id])
      Rails.logger.info("Creating reservation with params: #{reservation_params.inspect}")
      Rails.logger.info("Start time before creation: #{reservation_params[:start_time].inspect}")
      
      reservation = guest.reservations.new(reservation_params) 
      reservation.restaurant_id = params[:restaurant_id]
      reservation.save!
      json_response(reservation)
    end

    def destroy
      json_response(@reservation.destroy)
    end

    private

    def reservation_params
      params.require(:reservation).permit(:status, :start_time, :covers, :notes, 
                                         :qr_code_image, :hash_id, :table, :metadata)
    end

    def parse_start_time
      return unless params[:reservation][:start_time].is_a?(String)

      Rails.logger.info("Original start_time: #{params[:reservation][:start_time]}")
      
      # Check if it's already in ISO 8601 format (e.g. "2025-04-02T21:30:00.000Z")
      if params[:reservation][:start_time] =~ /^\d{4}-\d{2}-\d{2}T/
        # It's already in ISO format, parse directly
        parsed_time = DateTime.parse(params[:reservation][:start_time])
        Rails.logger.info("Parsed ISO format date: #{parsed_time}, year: #{parsed_time.year}, month: #{parsed_time.month}, day: #{parsed_time.day}")
        params[:reservation][:start_time] = parsed_time
      else
        # It's a timestamp, convert from seconds
        timestamp = params[:reservation][:start_time].to_i
        parsed_time = Time.at(timestamp).to_datetime
        Rails.logger.info("Parsed timestamp: #{parsed_time}, year: #{parsed_time.year}, month: #{parsed_time.month}, day: #{parsed_time.day}")
        params[:reservation][:start_time] = parsed_time
      end
      
      Rails.logger.info("Final parsed start_time: #{params[:reservation][:start_time]}")
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
  end
end
