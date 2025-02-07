# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /signup" do
    let(:valid_attributes) do
      { 
        email: "user@example.com", 
        password: "password", 
        password_confirmation: "password" 
      }
    end
    let(:invalid_attributes) do
      { 
        email: "user@example.com", 
        password: "password", 
        password_confirmation: "mismatch" 
      }
    end

    context "with valid attributes" do
      it "creates a user and returns user data without token" do
        post "/signup", params: valid_attributes
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json).to have_key("user")
        expect(json["user"]).to include("email" => "user@example.com")
        expect(json).not_to have_key("token")
      end
    end

    context "with invalid attributes" do
      it "returns errors" do
        post "/signup", params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json).to have_key("errors")
      end
    end
  end
end

