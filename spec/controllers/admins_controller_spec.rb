require 'rails_helper'

RSpec.describe "AdminsController", type: :request do
  include JsonWebToken

  let!(:admin) { FactoryBot.create(:admin) }
  let(:token) { jwt_encode(admin_id: admin.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }

  describe "GET /admins" do
    before { get "/admins", headers: headers }

    it "returns all admins" do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  describe "GET /admins/:id" do
    before { get "/admins/#{admin.id}", headers: headers }

    it "returns the requested admin" do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(admin.id)
    end
  end

  describe "POST /admins" do
    let(:valid_attributes) { { username: "new_admin", password: "securepass" }.to_json }

    before { post "/admins", params: valid_attributes, headers: headers }

    it "creates a new admin" do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["username"]).to eq("new_admin")
    end
  end

  # describe "PATCH /admins/:id" do
  #   context "when request is valid" do
  #     let(:update_attributes) { { username: "changed-username", password: "newpass" }.to_json }

  #     before { put "/admins/#{admin.id}", params: update_attributes, headers: headers }

  #     it "updates the admin and returns only the changed attributes" do
  #       parsed_response = JSON.parse(response.body)

  #       expect(response).to have_http_status(:ok)
  #       expect(parsed_response).to eq({ "username" => "changed-username" }) # Updated expectation
  #     end
  #   end
  # end


  # describe "DELETE /admins/:id" do
  #   before { delete "/admins/#{admin.id}", headers: headers }

  #   it "deletes the admin" do
  #     expect(response).to have_http_status(:ok)
  #   end
  # end

  describe "GET /admins/platform_stats" do
    before { get "/admins/platform_stats", headers: headers }

    it "returns platform statistics" do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admins/loan_distributions" do
    before { get "/admins/loan_distributions", headers: headers }

    it "returns loan distributions" do
      expect(response).to have_http_status(:ok)
    end
  end
end
