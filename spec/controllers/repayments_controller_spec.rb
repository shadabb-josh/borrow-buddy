require 'rails_helper'

RSpec.describe "RepaymentsController", type: :request do
  include JsonWebToken

  let!(:admin) { FactoryBot.create(:admin) }
  let(:token) { jwt_encode(admin_id: admin.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }

  let!(:repayments) { FactoryBot.create_list(:repayment, 3) }
  let(:repayment) { repayments.first }

  describe "GET /repayments" do
    before { get "/repayments", headers: headers }

    it "returns all repayments" do
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(3) # Since we created 3 repayments
    end
  end

  describe "GET /repayments/:id" do
    context "when repayment exists" do
      before { get "/repayments/#{repayment.id}", headers: headers }

      it "returns the requested repayment" do
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["id"]).to eq(repayment.id)
      end
    end

    context "when repayment does not exist" do
      before { get "/repayments/99999", headers: headers } # Assuming this ID doesn't exist

      it "returns a not found error" do
        expect(response).to have_http_status(:not_found)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["error"]).to eq(I18n.t("responses.repayments.not_found"))
      end
    end
  end
end
