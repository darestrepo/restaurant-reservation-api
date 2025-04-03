require 'swagger_helper'

RSpec.describe 'Registration API', type: :request do
  path '/users' do
    post 'User registration' do
      tags '1-Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password' },
              password_confirmation: { type: :string, example: 'password' },
              restaurant_id: { type: :integer, nullable: true, example: 1 },
              active: { type: :boolean, example: true },
              role: { type: :integer, example: 1, description: '0=admin, 1=restaurant, 2=guest' },
              name: { type: :string, example: 'John Doe', nullable: true },
              job: { type: :string, example: 'Chef', nullable: true }
            },
            required: ['email', 'password', 'password_confirmation', 'role']
          }
        },
        required: ['user']
      }

      response '200', 'user registered successfully' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            authentication_token: { type: :string },
            role: { type: :integer, description: '0=admin, 1=restaurant, 2=guest' },
            restaurant_id: { type: :integer, nullable: true, description: 'ID of the restaurant this user belongs to' },
            active: { type: :boolean },
            name: { type: :string, nullable: true },
            job: { type: :string, nullable: true }
          }
        let(:user) do
          {
            user: {
              email: 'test@example.com',
              password: 'password',
              password_confirmation: 'password',
              role: 1,
              restaurant_id: 1,
              active: true,
              name: 'John Doe',
              job: 'Chef'
            }
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            errors: {
              type: :object,
              properties: {
                email: { type: :array, items: { type: :string } }
              }
            }
          }
        let(:user) { { user: { email: '', password: 'password', password_confirmation: 'different', role: 1 } } }
        run_test!
      end
    end
  end
end 