require 'rails_helper'

RSpec.describe AdminRegister, type: :service do
  let(:valid_params) { { username: "admin_user", password: "securepass123" } }
  let(:invalid_params) { { username: "", password: "" } }

  describe "#call" do
    context "when valid params are provided" do
      it "creates a new admin successfully" do
        service = AdminRegister.new(valid_params)

        expect { service.call }.to change(Admin, :count).by(1)
        expect(service.call).to be_a(Admin)
      end
    end

    context "when invalid params are provided" do
      it "raises an error with validation messages" do
        service = AdminRegister.new(invalid_params)

        expect { service.call }.to raise_error(StandardError)
      end
    end
  end
end
