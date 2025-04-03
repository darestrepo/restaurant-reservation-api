require 'swagger_helper'

RSpec.describe 'Reservations API', type: :request do
  path '/v1/restaurants/{restaurant_id}/guests/{guest_id}/reservations' do
    parameter name: :restaurant_id, in: :path, type: :integer
    parameter name: :guest_id, in: :path, type: :integer

    get 'List all reservations for a guest' do
      tags 'Reservations'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'reservations found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              status: { type: :integer },
              start_time: { type: :string, format: 'date-time' },
              covers: { type: :integer },
              notes: { type: :string, nullable: true },
              restaurant_id: { type: :integer },
              guest_id: { type: :integer },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              qr_code_image: { type: :string, nullable: true },
              hash_id: { type: :string, nullable: true },
              table: { type: :string, nullable: true },
              metadata: { type: :object, nullable: true },
              confirmation_request: { type: :boolean },
              confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
            }
          }
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        run_test!
      end
    end

    post 'Create a reservation' do
      tags 'Reservations'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          reservation: {
            type: :object,
            properties: {
              status: { type: :integer, example: 1, description: '0=requested, 1=pending, 2=booked, 3=ended, 4=cancelled, 5=noshow' },
              start_time: { type: :string, example: '2025-04-15T19:30:00Z', description: 'ISO 8601 format or UNIX timestamp' },
              covers: { type: :integer, example: 2 },
              notes: { type: :string, example: 'Window seat preferred', nullable: true },
              qr_code_image: { type: :string, nullable: true },
              table: { type: :string, example: 'Table 7', nullable: true },
              metadata: { 
                type: :object, 
                example: { 
                  special_occasion: 'Birthday',
                  food_preferences: 'Vegetarian'
                },
                nullable: true 
              },
              confirmation_request: { type: :boolean, example: false },
              confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
            },
            required: ['status', 'start_time', 'covers']
          }
        },
        required: ['reservation']
      }

      response '200', 'reservation created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            status: { type: :integer },
            start_time: { type: :string, format: 'date-time' },
            covers: { type: :integer },
            notes: { type: :string, nullable: true },
            restaurant_id: { type: :integer },
            guest_id: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            qr_code_image: { type: :string, nullable: true },
            hash_id: { type: :string, nullable: true },
            table: { type: :string, nullable: true },
            metadata: { type: :object, nullable: true },
            confirmation_request: { type: :boolean },
            confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
          }
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        let(:reservation) { { 
          reservation: { 
            status: 1,
            start_time: '2025-04-15T19:30:00Z',
            covers: 2,
            notes: 'Window seat preferred'
          } 
        } }
        run_test!
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/guests/{guest_id}/reservations/{id}' do
    parameter name: :restaurant_id, in: :path, type: :integer
    parameter name: :guest_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Retrieve a reservation' do
      tags 'Reservations'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'reservation found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            status: { type: :integer },
            start_time: { type: :string, format: 'date-time' },
            covers: { type: :integer },
            notes: { type: :string, nullable: true },
            restaurant_id: { type: :integer },
            guest_id: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            qr_code_image: { type: :string, nullable: true },
            hash_id: { type: :string, nullable: true },
            table: { type: :string, nullable: true },
            metadata: { type: :object, nullable: true },
            confirmation_request: { type: :boolean },
            confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
          }
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        let(:id) { 1 }
        run_test!
      end
    end

    put 'Update a reservation' do
      tags 'Reservations'
      consumes 'application/json'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          reservation: {
            type: :object,
            properties: {
              status: { type: :integer },
              start_time: { type: :string },
              covers: { type: :integer },
              notes: { type: :string, nullable: true },
              table: { type: :string, nullable: true },
              metadata: { type: :object, nullable: true },
              confirmation_request: { type: :boolean }
            }
          }
        }
      }

      response '200', 'reservation updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            status: { type: :integer },
            start_time: { type: :string, format: 'date-time' },
            covers: { type: :integer },
            notes: { type: :string, nullable: true },
            restaurant_id: { type: :integer },
            guest_id: { type: :integer },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            qr_code_image: { type: :string, nullable: true },
            hash_id: { type: :string, nullable: true },
            table: { type: :string, nullable: true },
            metadata: { type: :object, nullable: true },
            confirmation_request: { type: :boolean },
            confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
          }
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        let(:id) { 1 }
        let(:reservation) { { 
          reservation: { 
            status: 2,
            covers: 4,
            table: 'Table 12'
          } 
        } }
        run_test!
      end
    end

    delete 'Delete a reservation' do
      tags 'Reservations'
      security [{ ApiKeyAuth: [] }]

      response '200', 'reservation deleted' do
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        let(:id) { 1 }
        run_test!
      end
    end

    path '/v1/restaurants/{restaurant_id}/guests/{guest_id}/reservations/{id}/request_confirmation' do
      parameter name: :restaurant_id, in: :path, type: :integer
      parameter name: :guest_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      post 'Request confirmation for a guest reservation' do
        tags 'Reservations'
        produces 'application/json'
        security [{ ApiKeyAuth: [] }]

        response '200', 'confirmation request sent successfully' do
          schema type: :object,
            properties: {
              reservation: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  status: { type: :integer },
                  start_time: { type: :string, format: 'date-time' },
                  covers: { type: :integer },
                  notes: { type: :string, nullable: true },
                  restaurant_id: { type: :integer },
                  guest_id: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  updated_at: { type: :string, format: 'date-time' },
                  qr_code_image: { type: :string, nullable: true },
                  hash_id: { type: :string, nullable: true },
                  table: { type: :string, nullable: true },
                  metadata: { type: :object, nullable: true },
                  confirmation_request: { type: :boolean },
                  confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
                }
              },
              message: { type: :string }
            }
          let(:restaurant_id) { 1 }
          let(:guest_id) { 1 }
          let(:id) { 1 }
          run_test!
        end
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/reservations/by_hash/{hash_id}' do
    parameter name: :restaurant_id, in: :path, type: :integer
    parameter name: :hash_id, in: :path, type: :string

    get 'Retrieve a reservation by hash ID at restaurant level' do
      tags 'Reservations'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'reservation found by hash' do
        schema type: :object,
          properties: {
            reservation: {
              type: :object,
              properties: {
                id: { type: :integer },
                status: { type: :integer },
                start_time: { type: :string, format: 'date-time' },
                covers: { type: :integer },
                notes: { type: :string, nullable: true },
                restaurant_id: { type: :integer },
                guest_id: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                qr_code_image: { type: :string, nullable: true },
                hash_id: { type: :string },
                table: { type: :string, nullable: true },
                metadata: { type: :object, nullable: true },
                confirmation_request: { type: :boolean },
                confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
              }
            },
            guest: {
              type: :object,
              properties: {
                id: { type: :integer },
                first_name: { type: :string },
                last_name: { type: :string },
                phone: { type: :string },
                email: { type: :string },
                restaurant_id: { type: :integer },
                notes: { type: :string, nullable: true },
                allergies: { type: :string, nullable: true }
              }
            },
            recent_reservations_count: { type: :integer }
          }
        let(:restaurant_id) { 1 }
        let(:hash_id) { '010425_XyZaB' }
        run_test!
      end

      response '404', 'reservation not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:restaurant_id) { 1 }
        let(:hash_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/v1/restaurants/{restaurant_id}/guests/{guest_id}/reservations/by_hash/{hash_id}' do
    parameter name: :restaurant_id, in: :path, type: :integer
    parameter name: :guest_id, in: :path, type: :integer
    parameter name: :hash_id, in: :path, type: :string

    get 'Retrieve a reservation by hash ID for a specific guest' do
      tags 'Reservations'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'reservation found by hash' do
        schema type: :object,
          properties: {
            reservation: {
              type: :object,
              properties: {
                id: { type: :integer },
                status: { type: :integer },
                start_time: { type: :string, format: 'date-time' },
                covers: { type: :integer },
                notes: { type: :string, nullable: true },
                restaurant_id: { type: :integer },
                guest_id: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                qr_code_image: { type: :string, nullable: true },
                hash_id: { type: :string },
                table: { type: :string, nullable: true },
                metadata: { type: :object, nullable: true },
                confirmation_request: { type: :boolean },
                confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
              }
            },
            guest: {
              type: :object,
              properties: {
                id: { type: :integer },
                first_name: { type: :string },
                last_name: { type: :string },
                phone: { type: :string },
                email: { type: :string },
                restaurant_id: { type: :integer },
                notes: { type: :string, nullable: true },
                allergies: { type: :string, nullable: true }
              }
            },
            recent_reservations_count: { type: :integer }
          }
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        let(:hash_id) { '010425_AbCdE' }
        run_test!
      end

      response '404', 'reservation not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:restaurant_id) { 1 }
        let(:guest_id) { 1 }
        let(:hash_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/v1/public/restaurants/{restaurant_id}/reservations/by_hash/{hash_id}' do
    parameter name: :restaurant_id, in: :path, type: :integer
    parameter name: :hash_id, in: :path, type: :string

    get 'Public endpoint to retrieve a reservation by hash ID (no authentication required)' do
      tags 'Public Reservations'
      produces 'application/json'

      response '200', 'reservation found by hash (public)' do
        schema type: :object,
          properties: {
            reservation: {
              type: :object,
              properties: {
                id: { type: :integer },
                status: { type: :integer },
                start_time: { type: :string, format: 'date-time' },
                covers: { type: :integer },
                notes: { type: :string, nullable: true },
                restaurant_id: { type: :integer },
                guest_id: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                updated_at: { type: :string, format: 'date-time' },
                qr_code_image: { type: :string, nullable: true },
                hash_id: { type: :string },
                table: { type: :string, nullable: true },
                metadata: { type: :object, nullable: true },
                confirmation_request: { type: :boolean },
                confirmation_request_date: { type: :string, format: 'date-time', nullable: true }
              }
            },
            guest: {
              type: :object,
              properties: {
                id: { type: :integer },
                first_name: { type: :string },
                last_name: { type: :string },
                phone: { type: :string },
                email: { type: :string },
                restaurant_id: { type: :integer }
              }
            },
            recent_reservations_count: { type: :integer }
          }
        let(:restaurant_id) { 1 }
        let(:hash_id) { '010425_XyZaB' }
        run_test!
      end

      response '404', 'reservation not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:restaurant_id) { 1 }
        let(:hash_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/v1/reservations/pending_confirmations' do
    get 'List reservations ready for confirmation' do
      tags 'Reservations'
      produces 'application/json'
      security [{ ApiKeyAuth: [] }]

      response '200', 'pending confirmation messages retrieved' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              restaurant_id: { type: :integer },
              name: { type: :string },
              tenant_id: { type: :string, nullable: true },
              confirmation_header_text: { type: :string },
              confirmation_body_text: { type: :string },
              confirm_message_to: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    guest_id: { type: :integer },
                    full_name: { type: :string },
                    phone: { type: :string },
                    email: { type: :string },
                    reservation_id: { type: :integer },
                    start_time: { type: :string, format: 'date-time' },
                    covers: { type: :integer },
                    notes: { type: :string, nullable: true },
                    table: { type: :string, nullable: true },
                    metadata: { type: :object, nullable: true }
                  }
                }
              }
            }
          }
        run_test!
      end
    end
  end
end 