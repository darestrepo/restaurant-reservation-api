require 'swagger_helper'

RSpec.describe 'Guests API', type: :request do
  path '/v1/restaurants/{restaurant_id}/guests' do
    parameter name: :restaurant_id, in: :path, type: :integer

    get 'List all guests for a restaurant' do
      tags 'Guests'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'guests found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              first_name: { type: :string },
              last_name: { type: :string },
              phone: { type: :string },
              email: { type: :string },
              restaurant_id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              notes: { type: :string, nullable: true },
              allergies: { type: :string, nullable: true },
              metadata: { type: :object, nullable: true },
              full_name: { type: :string, nullable: true }
            }
          }
        let(:restaurant_id) { 1 }
        run_test!
      end
    end

    post 'Create a guest' do
      tags 'Guests'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :guest, in: :body, schema: {
        type: :object,
        properties: {
          guest: {
            type: :object,
            properties: {
              first_name: { type: :string, example: 'John', nullable: true },
              last_name: { type: :string, example: 'Doe', nullable: true },
              full_name: { type: :string, example: 'John Doe', nullable: true },
              phone: { type: :string, example: '555-123-4567' },
              email: { type: :string, example: 'john.doe@example.com' },
              notes: { type: :string, example: 'VIP guest', nullable: true },
              allergies: { type: :string, example: 'Nuts, Dairy', nullable: true },
              metadata: { 
                type: :object, 
                example: { 
                  preference: 'Window seat',
                  loyalty_points: 100
                },
                nullable: true 
              }
            },
            required: ['phone', 'email']
          }
        },
        required: ['guest']
      }

      response '200', 'guest created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            first_name: { type: :string },
            last_name: { type: :string },
            phone: { type: :string },
            email: { type: :string },
            restaurant_id: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            notes: { type: :string, nullable: true },
            allergies: { type: :string, nullable: true },
            metadata: { type: :object, nullable: true },
            full_name: { type: :string, nullable: true }
          }
        let(:restaurant_id) { 1 }
        let(:guest) { { 
          guest: { 
            first_name: 'John',
            last_name: 'Doe',
            phone: '555-123-4567',
            email: 'john.doe@example.com'
          } 
        } }
        run_test!
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/guests/search' do
    parameter name: :restaurant_id, in: :path, type: :integer

    post 'Search for guests by phone or email' do
      tags 'Guests'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :search_params, in: :body, schema: {
        type: :object,
        properties: {
          email: { 
            type: :string, 
            example: 'john.doe@example.com',
            description: 'Search guests by email. Used if phone is not provided.'
          },
          phone: { 
            type: :string, 
            example: '573204917701',
            description: 'Search guests by phone. Takes precedence over email if both are provided.'
          }
        },
        description: 'Requires either phone or email for searching.'
      }

      response '200', 'matching guests found' do
        schema type: :array,
          description: 'Returns a list of guests matching the search criteria. Does not include reservation data.',
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              first_name: { type: :string, nullable: true },
              last_name: { type: :string, nullable: true },
              phone: { type: :string },
              email: { type: :string },
              restaurant_id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              notes: { type: :string, nullable: true },
              allergies: { type: :string, nullable: true },
              metadata: { type: :object, nullable: true },
              full_name: { type: :string, nullable: true }
            }
          }
        let(:restaurant_id) { 1 }
        let(:search_params) { { 
          phone: '573204917701'
        } }
        run_test!
      end
      
      response '400', 'Bad Request - Missing phone or email' do
        let(:restaurant_id) { 1 }
        let(:search_params) { { } } 
        run_test!
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/guests/{id}' do
    parameter name: :restaurant_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a guest' do
      tags 'Guests'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'guest found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            first_name: { type: :string },
            last_name: { type: :string },
            phone: { type: :string },
            email: { type: :string },
            restaurant_id: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            notes: { type: :string, nullable: true },
            allergies: { type: :string, nullable: true },
            metadata: { type: :object, nullable: true },
            full_name: { type: :string, nullable: true }
          }
        let(:restaurant_id) { 1 }
        let(:id) { 1 }
        run_test!
      end
    end

    put 'Update a guest' do
      tags 'Guests'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :guest, in: :body, schema: {
        type: :object,
        properties: {
          guest: {
            type: :object,
            properties: {
              first_name: { type: :string, nullable: true },
              last_name: { type: :string, nullable: true },
              full_name: { type: :string, nullable: true },
              phone: { type: :string },
              email: { type: :string },
              notes: { type: :string, nullable: true },
              allergies: { type: :string, nullable: true },
              metadata: { type: :object, nullable: true }
            }
          }
        }
      }

      response '200', 'guest updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            first_name: { type: :string },
            last_name: { type: :string },
            phone: { type: :string },
            email: { type: :string },
            restaurant_id: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            notes: { type: :string, nullable: true },
            allergies: { type: :string, nullable: true },
            metadata: { type: :object, nullable: true },
            full_name: { type: :string, nullable: true }
          }
        let(:restaurant_id) { 1 }
        let(:id) { 1 }
        let(:guest) { { 
          guest: { 
            first_name: 'Updated',
            last_name: 'Guest',
            metadata: {
              preference: 'Booth seat'
            }
          } 
        } }
        run_test!
      end
    end

    delete 'Delete a guest' do
      tags 'Guests'
      security [{ ApiKeyAuth: [] }]

      response '200', 'guest deleted' do
        let(:restaurant_id) { 1 }
        let(:id) { 1 }
        run_test!
      end
    end
  end
end 