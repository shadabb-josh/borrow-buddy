require 'rails_helper'

RSpec.describe LoanUpdate, type: :service do
  let(:borrower) { create(:user) }
  let(:loan) { create(:loan, borrower: borrower, status: "pending") }

  before do
    ActiveJob::Base.queue_adapter = :test # Ensures deliver_later runs in tests
  end

  describe "#call" do
    context "when loan is successfully updated" do
      it "updates the loan and sends the correct email" do
        allow(UserMailer).to receive(:loan_approved).and_call_original

        service = LoanUpdate.new(loan, { status: Loan.statuses[:approved] }) # Use enum correctly
        updated_loan = service.call

        expect(updated_loan.status).to eq("approved")
        expect(UserMailer).to have_received(:loan_approved).with(borrower, "approved")
      end
    end

    context "when loan update fails" do
      it "raises an error" do
        allow(loan).to receive(:update).and_return(false)
        allow(loan).to receive_message_chain(:errors, :full_messages).and_return(["Update failed"])

        service = LoanUpdate.new(loan, { status: Loan.statuses[:approved] })

        expect { service.call }.to raise_error(StandardError, "Update failed")
      end
    end
  end
end
