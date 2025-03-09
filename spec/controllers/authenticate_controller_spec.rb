require 'rails_helper'

RSpec.describe "AuthenticateController", type: :request do
  let!(:admin) { FactoryBot.create(:admin, password: "securepass") }
  let!(:user) { FactoryBot.create(:user, password: "securepass") }

  describe "POST /auth/admin-login" do
    context "when credentials are valid" do
      let(:valid_credentials) { { username: admin.username, password: "securepass" } }

      before { post "/auth/admin-login", params: valid_credentials }

      it "returns a JWT token" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key("token")
      end
    end

    context "when username is incorrect" do
      before { post "/auth/admin-login", params: { username: "wrong", password: "securepass" } }

      it "returns an error" do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("admin.not_found"))
      end
    end

    context "when password is incorrect" do
      before { post "/auth/admin-login", params: { username: admin.username, password: "wrongpass" } }

      it "returns an unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("admin.incorrect_password"))
      end
    end
  end

  describe "POST /auth/user-login" do
    context "when credentials are valid" do
      let(:valid_credentials) { { email: user.email, password: "securepass" } }

      before { post "/auth/user-login", params: valid_credentials }

      it "returns a JWT token and user id" do
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(parsed_response).to have_key("token")
        expect(parsed_response["id"]).to eq(user.id)
      end
    end

    context "when email is incorrect" do
      before { post "/auth/user-login", params: { email: "wrong@example.com", password: "securepass" } }

      it "returns an error" do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("user.email_not_found"))
      end
    end

    context "when password is incorrect" do
      before { post "/auth/user-login", params: { email: user.email, password: "wrongpass" } }

      it "returns an unauthorized error" do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq(I18n.t("user.incorrect_password"))
      end
    end
  end
end
