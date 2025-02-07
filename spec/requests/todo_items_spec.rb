require 'rails_helper'

RSpec.describe "TodoItems API", type: :request do
  let!(:user)   { FactoryBot.create(:user) }
  let!(:todo)   { FactoryBot.create(:todo, user: user) }
  let!(:items)  { FactoryBot.create_list(:todo_item, 2, todo: todo) }
  let(:token)   { JWT.encode({ user_id: user.id, token_version: user.token_version }, Rails.application.secret_key_base, 'HS256') }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /todos/:todo_id/items/:iid" do
    let(:item) { items.first }
    it "retrieves the specific todo item" do
      get "/todos/#{todo.id}/items/#{item.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(item.id)
    end
  end

  describe "POST /todos/:todo_id/items" do
    it "creates a new todo item" do
      post "/todos/#{todo.id}/items", params: { title: "New Item", completed: false }, headers: headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("New Item")
      expect(json["completed"]).to eq(false)
    end
  end

  describe "PUT /todos/:todo_id/items/:iid" do
    let(:item) { items.first }
    it "updates a todo item" do
      put "/todos/#{todo.id}/items/#{item.id}", params: { title: "Updated Item", completed: true }, headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Updated Item")
      expect(json["completed"]).to eq(true)
    end
  end

  describe "DELETE /todos/:todo_id/items/:iid" do
    let!(:item) { FactoryBot.create(:todo_item, todo: todo) }
    it "deletes a todo item" do
      delete "/todos/#{todo.id}/items/#{item.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

