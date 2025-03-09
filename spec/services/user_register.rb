require 'rails_helper'

RSpec.describe UserRegister, type: :service do
  let(:valid_params) { attributes_for(:user) }
  let(:invalid_params) { { email: "invalid-email", password: "short" } } # Adjusted to trigger the actual validation error

  describe "#call" do
    context "when user registration is successful" do
      it "creates a user and sends a welcome email" do
        expect {
          service = UserRegister.new(valid_params)
          user = service.call
          expect(user).to be_persisted
        }.to have_enqueued_mail(UserMailer, :welcome_email)
      end
    end

    context "when user registration fails" do
      it "raises an error with validation messages" do
        service = UserRegister.new(invalid_params)
        expect { service.call }.to raise_error(StandardError, /Email Must be a valid email|Password is too short/)
      end
    end
  end
end
