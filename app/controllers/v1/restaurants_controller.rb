# frozen_string_literal: true

module V1
  class RestaurantsController < ApplicationController
    before_action :set_restaurant, except: %i[index create]
    before_action :parse_opening_times, only: %i[update create]

    authorize_resource

    def index
      if current_user.admin?
        restaurants = Restaurant.all
      else
        # For non-admin users, only show their assigned restaurant
        restaurants = Restaurant.where(id: current_user.restaurant_id)
      end
      json_response(restaurants.map(&method(:restaurant_json_format)))
    end

    def show
      json_response(restaurant_json_format(@restaurant))
    end

    def update
      @restaurant.update(restaurant_params)
      json_response(restaurant_json_format(@restaurant))
    end

    def create
      # Only admins can create restaurants
      json_response(restaurant_json_format(Restaurant.create!(restaurant_params)))
    end

    def destroy
      json_response(@restaurant.destroy)
    end

    private

    def restaurant_json_format(restaurant)
      { restaurant: restaurant, opening_times: restaurant.opening_times }
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :cuisines, :phone, :email, :location, 
                                         :channel_phone_id, :channel_token, :channel_number, 
                                         :tenant_id, :reservations_contacts, :metadata,
                                         :send_confirmation, :send_confirmation_before,
                                         :confirmation_header_text, :confirmation_body_text,
                                         opening_times_attributes: %i[day_of_week opening_time closing_time])
    end

    def parse_opening_times
      return unless params[:restaurant][:opening_times_attributes].is_a?(String)

      params[:restaurant][:opening_times_attributes] = JSON.parse(params[:restaurant][:opening_times_attributes])
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end
  end
end
