require 'rails_helper'

RSpec.describe UserUpdate, type: :service do
  let(:user) { create(:user, first_name: "Old", last_name: "Name", email: "old@example.com") }
  let(:valid_params) { { first_name: "New", last_name: "Updated", email: "new@example.com" } }
  let(:invalid_params) { { email: "invalid-email" } } # Triggers email validation error

  describe "#call" do
    context "when update is successful" do
      it "updates the user attributes" do
        service = UserUpdate.new(user, valid_params)
        updated_user = service.call

        expect(updated_user.first_name).to eq("New")
        expect(updated_user.last_name).to eq("Updated")
        expect(updated_user.email).to eq("new@example.com")
      end
    end

    context "when update fails" do
      it "raises an error with validation messages" do
        service = UserUpdate.new(user, invalid_params)

        expect { service.call }.to raise_error(StandardError, /Email/)
      end
    end
  end
end
