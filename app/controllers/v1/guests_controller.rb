# frozen_string_literal: true

module V1
  class GuestsController < ApplicationController
    before_action :set_restaurant
    before_action :set_guest, except: %i[index create search]

    authorize_resource

    def index
      json_response(@restaurant.guests)
    end

    def show
      json_response(@guest)
    end

    def update
      # Debug logs
      Rails.logger.debug "GUEST UPDATE - Params: #{params.inspect}"
      Rails.logger.debug "GUEST UPDATE - Metadata before: #{@guest.metadata.inspect}"
      
      result = @guest.update(guest_params)
      
      Rails.logger.debug "GUEST UPDATE - Result: #{result}"
      Rails.logger.debug "GUEST UPDATE - Metadata after: #{@guest.metadata.inspect}"
      Rails.logger.debug "GUEST UPDATE - Errors: #{@guest.errors.full_messages}" unless result
      
      json_response(@guest)
    end

    def create
      json_response(@restaurant.guests.create!(guest_params))
    end

    def destroy
      json_response(@guest.destroy)
    end
    
    # New search action
    def search
      # Start with guests associated with this restaurant
      guests_query = @restaurant.guests
      
      # Filter by phone or email
      if search_params[:phone].present?
        guests_query = guests_query.where(phone: search_params[:phone])
      elsif search_params[:email].present?
        guests_query = guests_query.where(email: search_params[:email])
      else
        # If neither phone nor email is provided, return an empty array or handle as an error
        # For now, let's return empty as the search is specific
        guests_query = Guest.none 
      end
      
      # Find guests matching the criteria
      matched_guests = guests_query.limit(20) # Add a limit to avoid large responses
      
      # Return only guest information
      json_response(matched_guests)
    end

    private

    def guest_params
      # We need to permit the metadata as a hash with any keys
      permitted = params.require(:guest).permit(:first_name, :last_name, :full_name, :phone, :email, :notes, :allergies, metadata: {})
      permitted
    end
    
    def search_params
      params.permit(:email, :phone)
    end

    def set_guest
      @guest = Guest.find(params[:id])
      
      # Ensure the guest belongs to the restaurant in the URL
      unless @guest.restaurant_id == @restaurant.id
        raise ActiveRecord::RecordNotFound
      end
      
      # Ensure the guest belongs to the user's restaurant
      unless current_user.admin? || @guest.restaurant_id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :read, Guest)
      end
    end
    
    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
      
      # Ensure the restaurant is the user's assigned restaurant
      unless current_user.admin? || @restaurant.id == current_user.restaurant_id
        raise CanCan::AccessDenied.new("Not authorized!", :read, Restaurant)
      end
    end
  end
end
