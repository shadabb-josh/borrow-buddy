require 'rails_helper'

RSpec.describe LoanDestroy, type: :service do
  let(:loan) { create(:loan) }

  describe "#call" do
    context "when loan is successfully destroyed" do
      it "returns a success message" do
        service = LoanDestroy.new(loan)
        expect(service.call).to eq({ 'message': I18n.t("loan.deleted") })
      end
    end

    context "when loan cannot be destroyed" do
      before do
        allow(loan).to receive(:destroy).and_return(false) # Simulate failure
        allow(loan).to receive_message_chain(:errors, :full_messages).and_return(["Loan cannot be deleted"])
      end

      it "raises an error with loan errors" do
        service = LoanDestroy.new(loan)
        expect { service.call }.to raise_error(StandardError, "Loan cannot be deleted")
      end
    end
  end
end
