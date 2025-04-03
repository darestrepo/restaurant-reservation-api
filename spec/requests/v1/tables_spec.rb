require 'rails_helper'
require 'swagger_helper'

RSpec.describe "V1::Tables", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  path '/v1/restaurants/{restaurant_id}/tables' do
    parameter name: :restaurant_id, in: :path, type: :integer, description: 'ID of the restaurant'

    get 'List tables for a restaurant' do
      tags 'Tables'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'list of tables' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              restaurant_id: { type: :integer },
              name: { type: :string },
              section: { type: :string, nullable: true },
              capacity: { type: :integer },
              position_x: { type: :integer, nullable: true },
              position_y: { type: :integer, nullable: true },
              metadata: { type: :object, nullable: true },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ 'id', 'restaurant_id', 'name', 'capacity', 'created_at', 'updated_at' ]
          }
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        run_test!
      end
    end

    post 'Create a table' do
      tags 'Tables'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :table, in: :body, schema: {
        type: :object,
        properties: {
          table: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Table 10' },
              section: { type: :string, example: 'Main Dining Room', nullable: true },
              capacity: { type: :integer, example: 4 },
              position_x: { type: :integer, example: 100, nullable: true },
              position_y: { type: :integer, example: 250, nullable: true },
              metadata: { type: :object, example: { style: 'booth', view: 'window' }, nullable: true }
            },
            required: ['name', 'capacity']
          }
        },
        required: ['table']
      }

      response '201', 'table created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            restaurant_id: { type: :integer },
            name: { type: :string },
            section: { type: :string, nullable: true },
            capacity: { type: :integer },
            position_x: { type: :integer, nullable: true },
            position_y: { type: :integer, nullable: true },
            metadata: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:table) { { table: { name: 'T1', capacity: 2 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:table) { { table: { name: '' } } } # Missing capacity
        run_test!
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/tables/{id}' do
    parameter name: :restaurant_id, in: :path, type: :integer, description: 'ID of the restaurant'
    parameter name: :id, in: :path, type: :integer, description: 'ID of the table'

    get 'Retrieve a table' do
      tags 'Tables'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'table found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            restaurant_id: { type: :integer },
            name: { type: :string },
            section: { type: :string, nullable: true },
            capacity: { type: :integer },
            position_x: { type: :integer, nullable: true },
            position_y: { type: :integer, nullable: true },
            metadata: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:table, restaurant: restaurant).id }
        run_test!
      end

      response '404', 'table not found' do
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:id) { 9999 }
        run_test!
      end
    end

    put 'Update a table' do
      tags 'Tables'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :table, in: :body, schema: {
        type: :object,
        properties: {
          table: {
            type: :object,
            properties: {
              name: { type: :string },
              section: { type: :string, nullable: true },
              capacity: { type: :integer },
              position_x: { type: :integer, nullable: true },
              position_y: { type: :integer, nullable: true },
              metadata: { type: :object, nullable: true }
            }
          }
        }
      }

      response '200', 'table updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            restaurant_id: { type: :integer },
            name: { type: :string },
            section: { type: :string, nullable: true },
            capacity: { type: :integer },
            position_x: { type: :integer, nullable: true },
            position_y: { type: :integer, nullable: true },
            metadata: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:table, restaurant: restaurant).id }
        let(:table) { { table: { name: 'Updated Table Name', capacity: 6 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:table, restaurant: restaurant).id }
        let(:table) { { table: { capacity: -1 } } } # Invalid capacity
        run_test!
      end
    end

    delete 'Delete a table' do
      tags 'Tables'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '204', 'table deleted' do
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:table, restaurant: restaurant).id }
        run_test!
      end

      response '404', 'table not found' do
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:id) { 9999 }
        run_test!
      end
    end
  end
end
