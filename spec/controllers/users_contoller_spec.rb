require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  include JsonWebToken

  before(:each) do
    User.delete_all
  end

  let!(:user) { FactoryBot.create(:user) }  
  let(:token) { jwt_encode(user_id: user.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  let(:valid_attributes) do
    {
      first_name: "Updated",
      last_name: "User",
      email: "updated@example.com",
      pan_number: "ABCDE1234F",
      adhaar_number: "123412341234",
      status: "active",
      balance: 2000.0,
      account_number: "1234567890",
      ifsc: "HDFC0001234",
      pin: "1234"
    }
  end

  describe "GET /users/:id" do
    before { get "/users/#{user.id}", headers: headers }

    it "returns user with given id" do
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(parsed_response["id"]).to eq(user.id)
    end
  end

  describe "PUT /users/:id" do
    context "when request is valid" do
      before { put "/users/#{user.id}", params: valid_attributes, headers: headers }

      it "updates the user" do
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(parsed_response["first_name"]).to eq("Updated")
        expect(parsed_response["email"]).to eq("updated@example.com")
      end
    end

    context "when request is invalid" do
      before { put "/users/#{user.id}", params: { email: "" }, headers: headers }

      it "returns an error" do
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(parsed_response["errors"]).to be_present
      end
    end
  end

  describe "DELETE /users/:id" do
    before { delete "/users/#{user.id}", headers: headers }

    it "deletes the user" do
      expect(response).to have_http_status(200)
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end
