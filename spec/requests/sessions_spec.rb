require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/users/sign_in' do
    post 'User sign in' do
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
              password: { type: :string, example: 'password' }
            },
            required: ['email', 'password']
          }
        },
        required: ['user']
      }

      response '200', 'user signed in successfully' do
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
        let(:user) { { user: { email: 'user@example.com', password: 'password' } } }
        run_test!
      end

      response '401', 'invalid credentials' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:user) { { user: { email: 'user@example.com', password: 'wrong_password' } } }
        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete 'User sign out' do
      tags '1-Authentication'
      description 'Sign out a user by invalidating their session. Requires authentication headers.'
      security [{ ApiKeyAuth: [] }]

      # Add header parameters to make it clear authentication is required
      parameter name: 'X-User-Email', in: :header, type: :string, required: true, 
                description: 'Email address of the user signing out'
      parameter name: 'X-User-Token', in: :header, type: :string, required: true, 
                description: 'Authentication token received when signing in'
      
      response '200', 'signed out successfully' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Signed out successfully' }
          }
        let(:'X-User-Email') { 'user@example.com' }
        let(:'X-User-Token') { 'auth_token_123' }
        run_test!
      end

      response '401', 'not authenticated' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Not authenticated' }
          }
        # Missing or invalid authentication headers
        run_test!
      end
    end
  end
end 