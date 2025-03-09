require 'rails_helper'

RSpec.describe "TransactionsController", type: :request do
  include JsonWebToken

  let!(:admin) { FactoryBot.create(:admin) }
  let(:token) { jwt_encode(admin_id: admin.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }

  let!(:transactions) { FactoryBot.create_list(:transaction, 3) }
  let(:transaction) { transactions.first }

  describe "GET /transactions" do
    before { get "/transactions", headers: headers }

    it "returns all transactions" do
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(3) # Since we created 3 transactions
    end
  end

  describe "GET /transactions/:id" do
    context "when transaction exists" do
      before { get "/transactions/#{transaction.id}", headers: headers }

      it "returns the requested transaction" do
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["id"]).to eq(transaction.id)
      end
    end

    context "when transaction does not exist" do
      before { get "/transactions/99999", headers: headers } # Assuming this ID doesn't exist

      it "returns a not found error" do
        expect(response).to have_http_status(:not_found)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["error"]).to eq(I18n.t("transaction.not_found"))
      end
    end
  end
end
