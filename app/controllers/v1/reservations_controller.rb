# frozen_string_literal: true

module V1
  class ReservationsController < ApplicationController
    before_action :set_restaurant, except: [:pending_confirmations]
    before_action :set_guest, only: [:index, :create]
    before_action :set_reservation, except: %i[index create show_by_hash show_by_hash_at_restaurant pending_confirmations]
    before_action :parse_start_time, only: %i[update create]

    authorize_resource except: [:show_by_hash, :show_by_hash_at_restaurant, :pending_confirmations]
    skip_authorization_check only: [:show_by_hash, :show_by_hash_at_restaurant, :pending_confirmations]

    def index
      # Ensure we only return reservations for this restaurant
      reservations = @guest.reservations.where(restaurant_id: @restaurant.id)
      json_response(reservations)
    end

    def show
      json_response(@reservation)
    end

    def show_by_hash
      guest = Guest.find(params[:guest_id])
      
      # Ensure the guest belongs to this restaurant
      unless guest.restaurant_id == @restaurant.id
        raise ActiveRecord::RecordNotFound
      end
      
      # Ensure the guest and restaurant belong to the user's restaurant
      unless current_user.admin? || 
             (@restaurant.id == current_user.restaurant_id && 
              guest.restaurant_id == current_user.restaurant_id)
        raise CanCan::AccessDenied.new("Not authorized!", :read, Reservation)
      end
      
      begin
        reservation = Reservation.find_by!(hash_id: params[:hash_id], restaurant_id: @restaurant.id, guest_id: guest.id)
        
        # Get guest's reservations from last 6 months based on created_at
        six_months_ago = DateTime.now - 6.months
        recent_reservations_count = guest.reservations.where('created_at > ? AND restaurant_id = ?', six_months_ago, @restaurant.id).count
        
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
      # Ensure the restaurant belongs to the user's restaurant
      unless current_user.admin? || @restaurant.id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :read, Reservation)
      end
      
      begin
        reservation = Reservation.find_by!(hash_id: params[:hash_id], restaurant_id: @restaurant.id)
        guest = reservation.guest
        
        # Get guest's reservations from last 6 months based on created_at
        six_months_ago = DateTime.now - 6.months
        recent_reservations_count = guest.reservations.where('created_at > ? AND restaurant_id = ?', six_months_ago, @restaurant.id).count
        
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
      Rails.logger.info("Creating reservation with params: #{reservation_params.inspect}")
      Rails.logger.info("Start time before creation: #{reservation_params[:start_time].inspect}")
      
      reservation = @guest.reservations.new(reservation_params) 
      reservation.restaurant_id = @restaurant.id
      
      # Ensure the restaurant is the user's restaurant
      unless current_user.admin? || reservation.restaurant_id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :create, Reservation)
      end
      
      reservation.save!
      json_response(reservation)
    end

    def destroy
      json_response(@reservation.destroy)
    end

    def request_confirmation
      # Ensure the reservation belongs to the user's restaurant
      unless current_user.admin? || @reservation.restaurant_id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :update, Reservation)
      end
      
      @reservation.update(confirmation_request: true)
      
      response_data = {
        reservation: @reservation,
        message: "Confirmation request sent successfully"
      }
      
      json_response(response_data)
    end

    def pending_confirmations
      # Find all restaurants with send_confirmation enabled
      restaurants_with_confirmation = Restaurant.where(send_confirmation: true)
      
      result = []
      
      # Process each restaurant
      restaurants_with_confirmation.each do |restaurant|
        # Calculate the time window for sending confirmations
        now = Time.current
        confirmation_before_hours = restaurant.send_confirmation_before
        
        # Convert hours to seconds for time calculations
        confirmation_before_seconds = confirmation_before_hours * 3600
        buffer_seconds = 35 * 60 # 35 minutes in seconds
        
        # Find reservations that need confirmation
        pending_reservations = Reservation.where(
          restaurant_id: restaurant.id,
          confirmation_request: false,
          status: [Reservation.statuses[:requested], Reservation.statuses[:pending]]
        ).where(
          "start_time > ? AND start_time <= ?", 
          now,
          now + confirmation_before_seconds
        )
        
        # Skip if no pending reservations found
        next if pending_reservations.empty?
        
        # Prepare the result for this restaurant
        confirm_message_to = []
        
        # Add each reservation's details
        pending_reservations.each do |reservation|
          # Calculate hours until reservation
          hours_until_reservation = ((reservation.start_time - now) / 3600).to_f
          
          # Only include reservations that are in the confirmation window
          # (greater than confirmation_before - 35 minutes AND less than confirmation_before)
          min_hours = (confirmation_before_seconds - buffer_seconds) / 3600.0
          
          if hours_until_reservation <= confirmation_before_hours && hours_until_reservation >= min_hours
            guest = reservation.guest
            
            confirm_message_to << {
              guest_id: guest.id,
              full_name: guest.name,
              phone: guest.phone,
              email: guest.email,
              reservation_id: reservation.id,
              start_time: reservation.start_time,
              covers: reservation.covers,
              notes: reservation.notes,
              table: reservation.table,
              metadata: reservation.metadata
            }
          end
        end
        
        # Only add restaurant to results if it has reservations needing confirmation
        unless confirm_message_to.empty?
          result << {
            restaurant_id: restaurant.id,
            name: restaurant.name,
            tenant_id: restaurant.tenant_id,
            confirmation_header_text: restaurant.confirmation_header_text,
            confirmation_body_text: restaurant.confirmation_body_text,
            confirm_message_to: confirm_message_to
          }
        end
      end
      
      json_response(result)
    end

    private

    def reservation_params
      params.require(:reservation).permit(:status, :start_time, :covers, :notes, 
                                         :qr_code_image, :hash_id, :table, :metadata,
                                         :confirmation_request, :confirmation_request_date)
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

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
      
      # Ensure the restaurant is the user's assigned restaurant
      unless current_user.admin? || @restaurant.id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :read, Restaurant)
      end
    end

    def set_reservation
      @reservation = Reservation.find(params[:id])
      
      # Ensure the reservation belongs to this restaurant
      unless @reservation.restaurant_id == @restaurant.id
        raise ActiveRecord::RecordNotFound
      end
      
      # Ensure the reservation belongs to the user's restaurant
      unless current_user.admin? || @reservation.restaurant_id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :read, Reservation)
      end
    end
    
    def set_guest
      @guest = Guest.find(params[:guest_id])
      
      # Ensure the guest belongs to this restaurant
      unless @guest.restaurant_id == @restaurant.id
        raise ActiveRecord::RecordNotFound
      end
      
      # Ensure the guest belongs to the user's restaurant
      unless current_user.admin? || @guest.restaurant_id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :read, Guest)
      end
    end
  end
end
