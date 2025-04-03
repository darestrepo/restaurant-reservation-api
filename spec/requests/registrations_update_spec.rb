require 'swagger_helper'

RSpec.describe 'User Update API', type: :request do
  path '/users' do
    put 'Update user' do
      tags '1-Authentication'
      security [{ ApiKeyAuth: [] }]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'new_email@example.com' },
              current_password: { type: :string, example: 'current_password' },
              password: { type: :string, example: 'new_password' },
              password_confirmation: { type: :string, example: 'new_password' },
              name: { type: :string, example: 'Updated Name' },
              job: { type: :string, example: 'Updated Position' }
            }
          }
        },
        required: ['user']
      }

      response '200', 'user updated successfully' do
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
        let(:Authorization) { 'Bearer token123' }
        let(:user) { { user: { name: 'Updated Name', job: 'Updated Position' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            errors: {
              type: :object,
              properties: {
                email: { type: :array, items: { type: :string } },
                current_password: { type: :array, items: { type: :string } },
                password: { type: :array, items: { type: :string } }
              }
            }
          }
        let(:Authorization) { 'Bearer token123' }
        let(:user) { { user: { email: 'invalid', current_password: 'wrong' } } }
        run_test!
      end
    end

    delete 'Delete user' do
      tags '1-Authentication'
      security [{ ApiKeyAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'user deleted successfully' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Account has been successfully deleted.' }
          }
        let(:Authorization) { 'Bearer token123' }
        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'You need to sign in or sign up before continuing.' }
          }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end
end 