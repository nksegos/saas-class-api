require 'rails_helper'

RSpec.describe "Todos API", type: :request do
  let!(:user)   { FactoryBot.create(:user) }
  let!(:todos)  { FactoryBot.create_list(:todo, 3, user: user) }
  let(:token)   { JWT.encode({ user_id: user.id, token_version: user.token_version }, Rails.application.secret_key_base, 'HS256') }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /todos" do
    it "returns all todos for the user" do
      get "/todos", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
    end
  end

  describe "POST /todos" do
    it "creates a new todo" do
      post "/todos", params: { title: "New Todo" }, headers: headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("New Todo")
    end
  end

  describe "GET /todos/:id" do
    let(:todo) { todos.first }
    it "retrieves the specified todo" do
      get "/todos/#{todo.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(todo.id)
      expect(json).to have_key("todo_items")
    end
  end

  describe "PUT /todos/:id" do
    let(:todo) { todos.first }
    it "updates the todo" do
      put "/todos/#{todo.id}", params: { title: "Updated Todo" }, headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Updated Todo")
    end
  end

  describe "DELETE /todos/:id" do
    let!(:todo) { FactoryBot.create(:todo, user: user) }
    it "deletes the todo" do
      delete "/todos/#{todo.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect { todo.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

