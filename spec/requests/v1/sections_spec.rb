require 'swagger_helper'

RSpec.describe 'Sections API', type: :request do

  path '/v1/restaurants/{restaurant_id}/sections' do
    parameter name: :restaurant_id, in: :path, type: :integer, description: 'ID of the restaurant'

    get 'List sections for a restaurant' do
      tags 'Sections'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'list of sections' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              restaurant_id: { type: :integer },
              name: { type: :string },
              description: { type: :string, nullable: true },
              capacity: { type: :integer, nullable: true },
              metadata: { type: :object, nullable: true },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ 'id', 'restaurant_id', 'name', 'created_at', 'updated_at' ]
          }
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        run_test!
      end
    end

    post 'Create a section' do
      tags 'Sections'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :section, in: :body, schema: {
        type: :object,
        properties: {
          section: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Main Dining Room' },
              description: { type: :string, example: 'Primary seating area', nullable: true },
              capacity: { type: :integer, example: 50, nullable: true },
              metadata: { type: :object, example: { floor: 1, ambiance: 'casual' }, nullable: true }
            },
            required: ['name']
          }
        },
        required: ['section']
      }

      response '201', 'section created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            restaurant_id: { type: :integer },
            name: { type: :string },
            description: { type: :string, nullable: true },
            capacity: { type: :integer, nullable: true },
            metadata: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:section) { { section: { name: 'Patio' } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:section) { { section: { description: 'Only description' } } } # Missing name
        run_test!
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/sections/{id}' do
    parameter name: :restaurant_id, in: :path, type: :integer, description: 'ID of the restaurant'
    parameter name: :id, in: :path, type: :integer, description: 'ID of the section'

    get 'Retrieve a section' do
      tags 'Sections'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'section found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            restaurant_id: { type: :integer },
            name: { type: :string },
            description: { type: :string, nullable: true },
            capacity: { type: :integer, nullable: true },
            metadata: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:section, restaurant: restaurant).id }
        run_test!
      end

      response '404', 'section not found' do
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:id) { 9999 }
        run_test!
      end
    end

    put 'Update a section' do
      tags 'Sections'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :section, in: :body, schema: {
        type: :object,
        properties: {
          section: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string, nullable: true },
              capacity: { type: :integer, nullable: true },
              metadata: { type: :object, nullable: true }
            }
          }
        }
      }

      response '200', 'section updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            restaurant_id: { type: :integer },
            name: { type: :string },
            description: { type: :string, nullable: true },
            capacity: { type: :integer, nullable: true },
            metadata: { type: :object, nullable: true },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:section, restaurant: restaurant).id }
        let(:section) { { section: { name: 'Updated Patio', capacity: 30 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:section, restaurant: restaurant).id }
        let(:section) { { section: { name: '' } } } # Invalid name
        run_test!
      end
    end

    delete 'Delete a section' do
      tags 'Sections'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '204', 'section deleted' do
        let(:restaurant) { FactoryBot.create(:restaurant) }
        let(:restaurant_id) { restaurant.id }
        let(:id) { FactoryBot.create(:section, restaurant: restaurant).id }
        run_test!
      end

      response '404', 'section not found' do
        let(:restaurant_id) { FactoryBot.create(:restaurant).id }
        let(:id) { 9999 }
        run_test!
      end
    end
  end
end
