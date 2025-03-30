# frozen_string_literal: true

module V1
  class GuestsController < ApplicationController
    before_action :set_guest, except: %i[index create]

    authorize_resource

    def index
      restaurant = Restaurant.find(params[:restaurant_id])
      json_response(restaurant.guests)
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
      restaurant = Restaurant.find(params[:restaurant_id])
      json_response(restaurant.guests.create!(guest_params))
    end

    def destroy
      json_response(@guest.destroy)
    end

    private

    def guest_params
      # We need to permit the metadata as a hash with any keys
      permitted = params.require(:guest).permit(:first_name, :last_name, :phone, :email, :notes, :allergies, metadata: {})
      permitted
    end

    def set_guest
      @guest = Guest.find(params[:id])
    end
  end
end
