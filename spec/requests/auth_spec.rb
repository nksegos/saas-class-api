require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let!(:user) { FactoryBot.create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }

  describe "POST /auth/login" do
    context "with valid credentials" do
      it "returns a token and user data" do
        post "/auth/login", params: { email: user.email, password: "password" }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to have_key("token")
        expect(json).to have_key("user")
        expect(json["user"]["email"]).to eq(user.email)
      end
    end

    context "with invalid credentials" do
      it "returns an error" do
        post "/auth/login", params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json).to have_key("error")
      end
    end
  end

  describe "GET /auth/logout" do
    let(:token) { JWT.encode({ user_id: user.id, token_version: user.token_version }, Rails.application.secret_key_base, 'HS256') }

    it "logs out the user and invalidates the token" do
      # Logout using a valid token
      get "/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Logged out")

      # Subsequent access using the same token should fail
      get "/todos", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unauthorized)
      error_json = JSON.parse(response.body)
      expect(error_json).to have_key("error")
    end
  end
end

