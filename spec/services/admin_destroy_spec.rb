require 'rails_helper'

RSpec.describe AdminDestroy, type: :service do
  let!(:admin) { Admin.create!(username: "admin", password: "password123") }

  describe "#call" do
    context "when admin is successfully destroyed" do
      it "returns a success message" do
        service = AdminDestroy.new(admin)
        expect { service.call }.to change(Admin, :count).by(-1)
        expect(service.call).to eq({ message: I18n.t("admin.deleted") })
      end
    end

    context "when admin deletion fails" do
      it "raises an error with full messages" do
        allow(admin).to receive(:destroy).and_return(false)
        allow(admin).to receive_message_chain(:errors, :full_messages).and_return(["Deletion failed"])

        service = AdminDestroy.new(admin)
        expect { service.call }.to raise_error(StandardError, '["Deletion failed"]')
      end
    end
  end
end
