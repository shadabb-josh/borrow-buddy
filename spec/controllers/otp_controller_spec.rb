require 'rails_helper'

RSpec.describe "OtpController", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:parsed_response) { JSON.parse(response.body) }

  describe "POST /user/send-otp" do
    context "when the user exists" do
      before do
        allow(UserMailer).to receive_message_chain(:send_otp, :deliver_now)
        post "/user/send-otp", params: { email: user.email.downcase }
      end

      it "sends an OTP email" do
        expect(response).to have_http_status(:ok)
        expect(parsed_response["message"]).to eq(I18n.t("otp.sent"))
      end
    end

    context "when the user does not exist" do
      before do
        allow(User).to receive(:find_by).and_return(nil) # Prevents `generate_otp` NilClass error
        post "/user/send-otp", params: { email: "nonexistent@example.com" }
      end

      it "returns an unprocessable entity error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response["errors"]).to eq(I18n.t("user.not_found"))
      end
    end
  end
end
