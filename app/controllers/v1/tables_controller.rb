# frozen_string_literal: true

module V1
  class TablesController < ApplicationController
    before_action :set_restaurant
    before_action :set_table, only: %i[show update destroy]

    # Use CanCanCan to authorize actions
    # Ensures user can only manage tables for their own restaurant (or all if admin)
    authorize_resource :restaurant
    authorize_resource :table, through: :restaurant

    # GET /v1/restaurants/:restaurant_id/tables
    def index
      json_response(@restaurant.tables)
    end

    # GET /v1/restaurants/:restaurant_id/tables/:id
    def show
      json_response(@table)
    end

    # POST /v1/restaurants/:restaurant_id/tables
    def create
      @table = @restaurant.tables.create!(table_params)
      json_response(@table, :created)
    end

    # PUT /v1/restaurants/:restaurant_id/tables/:id
    def update
      @table.update!(table_params)
      json_response(@table)
    end

    # DELETE /v1/restaurants/:restaurant_id/tables/:id
    def destroy
      @table.destroy!
      head :no_content
    end

    private

    def table_params
      params.require(:table).permit(:name, :section, :capacity, :position_x, :position_y, metadata: {})
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def set_table
      @table = @restaurant.tables.find(params[:id])
    end
  end
end
