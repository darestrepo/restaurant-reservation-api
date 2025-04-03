require 'swagger_helper'

RSpec.describe 'Password API', type: :request do
  path '/users/password' do
    post 'Request password reset' do
      tags '1-Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' }
            },
            required: ['email']
          }
        },
        required: ['user']
      }

      response '200', 'reset password instructions sent' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'You will receive an email with instructions on how to reset your password in a few minutes.' }
          }
        let(:user) { { user: { email: 'user@example.com' } } }
        run_test!
      end

      response '422', 'email not found' do
        schema type: :object,
          properties: {
            errors: {
              type: :object,
              properties: {
                email: { type: :array, items: { type: :string } }
              }
            }
          }
        let(:user) { { user: { email: 'nonexistent@example.com' } } }
        run_test!
      end
    end

    put 'Reset password' do
      tags '1-Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              reset_password_token: { type: :string, example: 'abcdef123456' },
              password: { type: :string, example: 'new_password' },
              password_confirmation: { type: :string, example: 'new_password' }
            },
            required: ['reset_password_token', 'password', 'password_confirmation']
          }
        },
        required: ['user']
      }

      response '200', 'password updated successfully' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Your password has been changed successfully.' }
          }
        let(:user) { { user: { reset_password_token: 'token', password: 'new_password', password_confirmation: 'new_password' } } }
        run_test!
      end

      response '422', 'invalid token or passwords do not match' do
        schema type: :object,
          properties: {
            errors: {
              type: :object,
              properties: {
                reset_password_token: { type: :array, items: { type: :string } },
                password: { type: :array, items: { type: :string } }
              }
            }
          }
        let(:user) { { user: { reset_password_token: 'invalid', password: 'new', password_confirmation: 'different' } } }
        run_test!
      end
    end
  end
end 