require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include JsonWebToken
  controller do
    def index
      render json: { message: "Success" }
    end
  end

  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:admin_token) { jwt_encode(admin_id: admin.id) }
  let(:user_token) { jwt_encode(user_id: user.id) }
  let(:invalid_token) { "invalid.token.string" }

  describe "Authentication" do
    context "when admin is authenticated" do
      before do
        request.headers["Authorization"] = "Bearer #{admin_token}"
        get :index
      end

      it "sets @current_admin" do
        expect(controller.instance_variable_get(:@current_admin)).to eq(admin)
      end

      it "returns success response" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is authenticated" do
      before do
        request.headers["Authorization"] = "Bearer #{user_token}"
        get :index
      end

      it "sets @current_user" do
        expect(controller.instance_variable_get(:@current_user)).to eq(user)
      end
    end

    context "when no token is provided" do
      before { get :index }

      it "returns unauthorized error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to eq("Nil JSON web token")
      end
    end

    context "when an invalid token is provided" do
      before do
        request.headers["Authorization"] = "Bearer #{invalid_token}"
        get :index
      end

      it "returns an unauthorized response" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Invalid segment encoding")
      end
    end
  end
end
