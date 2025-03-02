require 'rails_helper'

RSpec.describe UserPasswordChange, type: :service do
  let!(:user) { create(:user, password: "oldpassword") }
  let(:valid_params) { { old_password: "oldpassword", new_password: "newpassword123" } }
  let(:invalid_params) { { old_password: "wrongpassword", new_password: "newpassword123" } }

  describe "#call" do
    context "when old password is correct" do
      it "changes the password successfully" do
        service = UserPasswordChange.new(user, valid_params)
        expect(service.call).to eq({ message: I18n.t("user.password_change") })
        expect(user.reload.authenticate("newpassword123")).to be_truthy
      end
    end

    context "when old password is incorrect" do
      it "raises an error" do
        service = UserPasswordChange.new(user, invalid_params)
        expect { service.call }.to raise_error(StandardError, I18n.t("user.incorrect_old_password"))
      end
    end

    context "when password update fails" do
      it "raises an error with full messages" do
        allow(user).to receive(:authenticate).with("oldpassword").and_return(true)
        allow(user).to receive(:update).and_return(false)
        allow(user).to receive_message_chain(:errors, :full_messages).and_return(["Password update failed"])

        service = UserPasswordChange.new(user, valid_params)
        expect { service.call }.to raise_error(StandardError, "Password update failed")
      end
    end
  end
end
