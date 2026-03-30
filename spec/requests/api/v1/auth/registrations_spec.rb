require 'rails_helper'

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth/sign_up" do
    let(:valid_params) do
      {
        user: {
          name: "New User",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    context "正常系" do
      it "returns 201 and creates the user" do
        expect {
          post "/api/v1/auth/sign_up", params: valid_params, as: :json
        }.to change(User, :count).by(1)

        expect(response.status).to eq(201)
        body = JSON.parse(response.body)
        expect(body["user"]["email"]).to eq("newuser@example.com")
        expect(body["user"]["name"]).to eq("New User")
      end

      it "returns a JWT token in the Authorization header" do
        post "/api/v1/auth/sign_up", params: valid_params, as: :json
        expect(response.headers["Authorization"]).to be_present
        expect(response.headers["Authorization"]).to match(/^Bearer /)
      end
    end

    context "異常系" do
      it "returns 422 when email is missing" do
        post "/api/v1/auth/sign_up",
             params: { user: { name: "Test", password: "password123", password_confirmation: "password123" } },
             as: :json
        expect(response.status).to eq(422)
      end

      it "returns 422 when password is too short" do
        post "/api/v1/auth/sign_up",
             params: { user: { name: "Test", email: "t@t.com", password: "abc", password_confirmation: "abc" } },
             as: :json
        expect(response.status).to eq(422)
      end

      it "returns 422 when email is already taken" do
        User.create!(name: "Existing", email: "taken@example.com", password: "password123")
        post "/api/v1/auth/sign_up",
             params: { user: { name: "Test", email: "taken@example.com", password: "password123", password_confirmation: "password123" } },
             as: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
