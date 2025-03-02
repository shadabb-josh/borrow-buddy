require 'rails_helper'

RSpec.describe UserDestroy, type: :service do
  let!(:user) { create(:user) }

  describe "#call" do
    context "when user is successfully deleted" do
      it "returns a success message" do
        service = UserDestroy.new(user)
        expect(service.call).to eq({ message: I18n.t("user.deleted") })
        expect(User.exists?(user.id)).to be_falsey
      end
    end

    context "when user deletion fails" do
      it "raises an error with full messages" do
        allow(user).to receive(:destroy).and_return(false)
        allow(user).to receive_message_chain(:errors, :full_messages).and_return(["Deletion failed"])

        service = UserDestroy.new(user)
        expect { service.call }.to raise_error(StandardError, "Deletion failed")
      end
    end
  end
end
