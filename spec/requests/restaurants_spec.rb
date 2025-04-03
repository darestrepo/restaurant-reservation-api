require 'swagger_helper'

RSpec.describe 'Restaurants API', type: :request do
  path '/v1/restaurants' do
    get 'List all restaurants' do
      tags 'Restaurants'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'restaurants found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              restaurant: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string },
                  cuisines: { type: :string },
                  phone: { type: :string },
                  email: { type: :string },
                  location: { type: :string },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' },
                  send_confirmation: { type: :boolean },
                  send_confirmation_before: { type: :integer },
                  confirmation_header_text: { type: :string },
                  confirmation_body_text: { type: :string }
                }
              },
              opening_times: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    day_of_week: { type: :integer },
                    opening_time: { type: :string },
                    closing_time: { type: :string },
                    restaurant_id: { type: :integer },
                    created_at: { type: :string, format: 'date-time' },
                    updated_at: { type: :string, format: 'date-time' }
                  }
                }
              }
            }
          }
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
          properties: {
            message: { type: :string },
            status: { type: :integer }
          }
        run_test!
      end
    end

    post 'Create a restaurant' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: {
              name: { type: :string, example: 'New Restaurant' },
              cuisines: { type: :string, example: 'italian, chinese' },
              phone: { type: :string, example: '555-123-4567' },
              email: { type: :string, example: 'info@restaurant.com' },
              location: { type: :string, example: '123 Main St, City' },
              send_confirmation: { type: :boolean, example: false },
              send_confirmation_before: { type: :integer, example: 24 },
              confirmation_header_text: { type: :string, example: 'Please confirm your reservation' },
              confirmation_body_text: { type: :string, example: 'We\'re looking forward to seeing you. Please confirm your reservation by replying YES.' },
              opening_times_attributes: {
                type: :array,
                example: [
                  {
                    day_of_week: 1,
                    opening_time: '09:00',
                    closing_time: '22:00'
                  }
                ],
                items: {
                  type: :object,
                  properties: {
                    day_of_week: { type: :integer },
                    opening_time: { type: :string },
                    closing_time: { type: :string }
                  }
                }
              }
            },
            required: ['name', 'cuisines', 'phone', 'email', 'location']
          }
        },
        required: ['restaurant']
      }

      response '200', 'restaurant created' do
        schema type: :object,
          properties: {
            restaurant: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                cuisines: { type: :string },
                phone: { type: :string },
                email: { type: :string },
                location: { type: :string },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                send_confirmation: { type: :boolean },
                send_confirmation_before: { type: :integer },
                confirmation_header_text: { type: :string },
                confirmation_body_text: { type: :string }
              }
            },
            opening_times: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  day_of_week: { type: :integer },
                  opening_time: { type: :string },
                  closing_time: { type: :string },
                  restaurant_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        let(:restaurant) { { 
          restaurant: { 
            name: 'Test Restaurant',
            cuisines: 'italian',
            phone: '555-123-4567',
            email: 'test@restaurant.com',
            location: '123 Test St',
            send_confirmation: false,
            send_confirmation_before: 24,
            confirmation_header_text: 'Please confirm your reservation',
            confirmation_body_text: 'We\'re looking forward to seeing you. Please confirm your reservation by replying YES.',
            opening_times_attributes: [
              {
                day_of_week: 1,
                opening_time: '09:00',
                closing_time: '22:00'
              }
            ]
          } 
        } }
        run_test!
      end
    end
  end

  path '/v1/restaurants/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a restaurant' do
      tags 'Restaurants'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'restaurant found' do
        schema type: :object,
          properties: {
            restaurant: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                cuisines: { type: :string },
                phone: { type: :string },
                email: { type: :string },
                location: { type: :string },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                send_confirmation: { type: :boolean },
                send_confirmation_before: { type: :integer },
                confirmation_header_text: { type: :string },
                confirmation_body_text: { type: :string }
              }
            },
            opening_times: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  day_of_week: { type: :integer },
                  opening_time: { type: :string },
                  closing_time: { type: :string },
                  restaurant_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'restaurant not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update a restaurant' do
      tags 'Restaurants'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :restaurant, in: :body, schema: {
        type: :object,
        properties: {
          restaurant: {
            type: :object,
            properties: {
              name: { type: :string },
              cuisines: { type: :string },
              phone: { type: :string },
              email: { type: :string },
              location: { type: :string },
              send_confirmation: { type: :boolean },
              send_confirmation_before: { type: :integer },
              confirmation_header_text: { type: :string },
              confirmation_body_text: { type: :string },
              opening_times_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    day_of_week: { type: :integer },
                    opening_time: { type: :string },
                    closing_time: { type: :string }
                  }
                }
              }
            }
          }
        }
      }

      response '200', 'restaurant updated' do
        schema type: :object,
          properties: {
            restaurant: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                cuisines: { type: :string },
                phone: { type: :string },
                email: { type: :string },
                location: { type: :string },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                send_confirmation: { type: :boolean },
                send_confirmation_before: { type: :integer },
                confirmation_header_text: { type: :string },
                confirmation_body_text: { type: :string }
              }
            },
            opening_times: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  day_of_week: { type: :integer },
                  opening_time: { type: :string },
                  closing_time: { type: :string },
                  restaurant_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' }
                }
              }
            }
          }
        let(:id) { 1 }
        let(:restaurant) { { 
          restaurant: { 
            name: 'Updated Restaurant',
            phone: '555-999-8888',
            send_confirmation: true,
            send_confirmation_before: 12,
            confirmation_header_text: 'Please confirm your upcoming reservation',
            confirmation_body_text: 'We can\'t wait to see you! Please confirm by replying YES.'
          } 
        } }
        run_test!
      end
    end

    delete 'Delete a restaurant' do
      tags 'Restaurants'
      security [{ ApiKeyAuth: [] }]

      response '200', 'restaurant deleted' do
        let(:id) { 1 }
        run_test!
      end
    end
  end
end 