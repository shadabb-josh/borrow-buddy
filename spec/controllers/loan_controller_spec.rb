require 'rails_helper'

RSpec.describe "LoansController", type: :request do
  include JsonWebToken

  before(:each) do
    Loan.delete_all
    User.delete_all
  end

  let!(:borrower) { FactoryBot.create(:user) }
  let!(:lender) { FactoryBot.create(:user) }
  let!(:loan) { FactoryBot.create(:loan, borrower: borrower, lender: lender) }
  let(:token) { jwt_encode(user_id: borrower.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:valid_attributes) do
    {
      borrower_id: borrower.id,
      lender_id: lender.id,
      amount: 5000.0,
      interest: 5.0,
      purpose: "Education Loan",
      status: "pending",
      repayment_till: "2025-12-31",
      expected_return: 5250.0
    }
  end

  describe "GET /loans" do
    before { get "/loans", headers: headers }

    it "returns all loans" do
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response).to be_an(Array)
    end
  end

  describe "GET /loans/:id" do
    before { get "/loans/#{loan.id}", headers: headers }

    it "returns the loan with given id" do
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response["id"]).to eq(loan.id)
    end
  end

  describe "POST /loans" do
    before { post "/loans", params: valid_attributes }

    it "creates a loan" do
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response["amount"]).to eq(5000.0)
    end
  end

  describe "PUT /loans/:id" do
    context "when request is valid" do
      before { put "/loans/#{loan.id}", params: valid_attributes, headers: headers }

      it "updates the loan" do
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(parsed_response["amount"]).to eq(5000.0)
      end
    end

    context "when request is invalid" do
      before { put "/loans/#{loan.id}", params: { amount: nil }, headers: headers }

      it "returns an error" do
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(parsed_response["errors"]).to be_present
      end
    end
  end

  describe "DELETE /loans/:id" do
    before { delete "/loans/#{loan.id}", headers: headers }

    it "deletes the loan" do
      expect(response).to have_http_status(200)
      expect(Loan.find_by(id: loan.id)).to be_nil
    end
  end
end
