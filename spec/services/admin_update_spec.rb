require 'rails_helper'

RSpec.describe AdminUpdate, type: :service do
  let!(:admin) { Admin.create!(username: "admin1", password: "password123") }

  describe "#call" do
    context "when update is successful" do
      let(:valid_params) { { username: "updated_admin" } }

      it "updates the admin and returns the updated object" do
        service = AdminUpdate.new(admin, valid_params)
        updated_admin = service.call

        expect(updated_admin).to be_a(Admin)
        expect(updated_admin.username).to eq("updated_admin")
      end
    end

    context "when update fails" do
      let(:invalid_params) { { username: nil } }

      it "raises an error with validation messages" do
        service = AdminUpdate.new(admin, invalid_params)

        expect { service.call }.to raise_error(StandardError, /Username can't be blank/)
      end
    end
  end
end
