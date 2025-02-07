require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/signup' do
    post 'Signup a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: ['email', 'password', 'password_confirmation']
      }

      response '201', 'User created successfully' do
        let(:user) { { email: 'user@example.com', password: 'password', password_confirmation: 'password' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('user')
          expect(data).not_to have_key('token')
        end
      end

      response '422', 'Invalid request' do
        let(:user) { { email: 'user@example.com', password: 'password', password_confirmation: 'mismatch' } }
        run_test!
      end
    end
  end
end

