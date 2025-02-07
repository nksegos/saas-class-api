require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/auth/login' do
    post 'User login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }

      response '200', 'User logged in successfully' do
        let(:credentials) { { email: 'user@example.com', password: 'password' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
          expect(data).to have_key('user')
        end
      end

      response '401', 'Invalid credentials' do
        let(:credentials) { { email: 'user@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/auth/logout' do
    get 'User logout' do
      tags 'Authentication'
      security [ bearerAuth: [] ]
      produces 'application/json'
      response '200', 'User logged out successfully' do
        # For test purposes, we simulate a valid JWT.
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('Logged out')
        end
      end
    end
  end
end

