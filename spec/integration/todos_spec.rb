# spec/integration/todos_spec.rb
require 'swagger_helper'

RSpec.describe 'Todos API', type: :request do
  path '/todos' do
    get 'List all todos with their items' do
      tags 'Todos'
      produces 'application/json'
      security [ bearerAuth: [] ]
      response '200', 'todos retrieved' do
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end

    post 'Create a new todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: ['title']
      }
      response '201', 'todo created' do
        let(:todo) { { title: 'My First Todo' } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '422', 'invalid request' do
        let(:todo) { { title: '' } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end
  end

  path '/todos/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Todo ID'

    get 'Get a todo' do
      tags 'Todos'
      produces 'application/json'
      security [ bearerAuth: [] ]
      response '200', 'todo found' do
        let(:id) { 1 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 9999 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end

    put 'Update a todo' do
      tags 'Todos'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :todo, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: ['title']
      }
      response '200', 'todo updated' do
        let(:id) { 1 }
        let(:todo) { { title: 'Updated Todo Title' } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { 1 }
        let(:todo) { { title: '' } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end

    delete 'Delete a todo and its items' do
      tags 'Todos'
      security [ bearerAuth: [] ]
      response '204', 'todo deleted' do
        let(:id) { 1 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '404', 'todo not found' do
        let(:id) { 9999 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end
  end
end

