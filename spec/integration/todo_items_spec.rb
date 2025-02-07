require 'swagger_helper'

RSpec.describe 'Todo Items API', type: :request do
  path '/todos/{todo_id}/items' do
    parameter name: :todo_id, in: :path, type: :integer, description: 'Todo ID'

    post 'Create a new todo item' do
      tags 'Todo Items'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :todo_item, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          completed: { type: :boolean }
        },
        required: ['title']
      }
      response '201', 'item created' do
        let(:todo_id) { 1 }
        let(:todo_item) { { title: 'New Todo Item', completed: false } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '422', 'invalid request' do
        let(:todo_id) { 1 }
        let(:todo_item) { { title: '', completed: false } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end
  end

  path '/todos/{todo_id}/items/{iid}' do
    parameter name: :todo_id, in: :path, type: :integer, description: 'Todo ID'
    parameter name: :iid, in: :path, type: :integer, description: 'Todo Item ID'

    get 'Retrieve a specific todo item' do
      tags 'Todo Items'
      produces 'application/json'
      security [ bearerAuth: [] ]
      response '200', 'item found' do
        let(:todo_id) { 1 }
        let(:iid) { 1 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '404', 'item not found' do
        let(:todo_id) { 1 }
        let(:iid) { 9999 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end

    put 'Update a specific todo item' do
      tags 'Todo Items'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :todo_item, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          completed: { type: :boolean }
        },
        required: ['title', 'completed']
      }
      response '200', 'item updated' do
        let(:todo_id) { 1 }
        let(:iid) { 1 }
        let(:todo_item) { { title: 'Updated Todo Item', completed: true } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '422', 'invalid request' do
        let(:todo_id) { 1 }
        let(:iid) { 1 }
        let(:todo_item) { { title: '', completed: false } }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end

    delete 'Delete a specific todo item' do
      tags 'Todo Items'
      security [ bearerAuth: [] ]
      response '204', 'item deleted' do
        let(:todo_id) { 1 }
        let(:iid) { 1 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end

      response '404', 'item not found' do
        let(:todo_id) { 1 }
        let(:iid) { 9999 }
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: 1, token_version: 1 }, Rails.application.secret_key_base, 'HS256')}" }
        run_test!
      end
    end
  end
end

