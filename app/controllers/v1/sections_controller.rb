# frozen_string_literal: true

module V1
  class SectionsController < ApplicationController
    before_action :set_restaurant
    before_action :set_section, only: %i[show update destroy]

    # Authorize based on restaurant and section within that restaurant
    authorize_resource :restaurant
    authorize_resource :section, through: :restaurant

    # GET /v1/restaurants/:restaurant_id/sections
    def index
      json_response(@restaurant.sections)
    end

    # GET /v1/restaurants/:restaurant_id/sections/:id
    def show
      json_response(@section)
    end

    # POST /v1/restaurants/:restaurant_id/sections
    def create
      @section = @restaurant.sections.create!(section_params)
      json_response(@section, :created)
    end

    # PUT /v1/restaurants/:restaurant_id/sections/:id
    def update
      @section.update!(section_params)
      json_response(@section)
    end

    # DELETE /v1/restaurants/:restaurant_id/sections/:id
    def destroy
      @section.destroy!
      head :no_content
    end

    private

    def section_params
      params.require(:section).permit(:name, :description, :capacity, metadata: {})
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_section
      @section = @restaurant.sections.find(params[:id])
    end
  end
end
