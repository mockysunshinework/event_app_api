require 'rails_helper'

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  let!(:user) { User.create!(name: "test_user", email: "test@example.com", password: "password123") }

  describe "POST /api/v1/auth/sign_in" do
    context "正常系" do
      it "returns 200 and user data" do
        post "/api/v1/auth/sign_in",
             params: { user: { email: user.email, password: "password123" } },
             as: :json
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body["user"]["id"]).to eq(user.id)
        expect(body["user"]["email"]).to eq(user.email)
      end

      it "returns a JWT token in the Authorization header" do
        post "/api/v1/auth/sign_in",
             params: { user: { email: user.email, password: "password123" } },
             as: :json
        expect(response.headers["Authorization"]).to be_present
        expect(response.headers["Authorization"]).to match(/^Bearer /)
      end
    end

    context "異常系" do
      it "returns 401 with wrong password" do
        post "/api/v1/auth/sign_in",
             params: { user: { email: user.email, password: "wrongpassword" } },
             as: :json
        expect(response.status).to eq(401)
      end

      it "returns 401 with non-existent email" do
        post "/api/v1/auth/sign_in",
             params: { user: { email: "nobody@example.com", password: "password123" } },
             as: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    it "returns 200 and revokes the token" do
      # Sign in first
      post "/api/v1/auth/sign_in",
           params: { user: { email: user.email, password: "password123" } },
           as: :json
      token = response.headers["Authorization"]

      # Sign out
      delete "/api/v1/auth/sign_out", headers: { "Authorization" => token }
      expect(response.status).to eq(200)

      # Verify token is revoked
      get "/api/v1/me/event_applications", headers: { "Authorization" => token }
      expect(response.status).to eq(401)
    end

    it "returns 401 without a token" do
      delete "/api/v1/auth/sign_out"
      expect(response.status).to eq(401)
    end
  end
end
