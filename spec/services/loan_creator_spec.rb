require 'rails_helper'

RSpec.describe LoanCreater, type: :service do
  let(:borrower) { create(:user) }
  let(:lender) { create(:user) }

  let(:valid_params) do
    {
      borrower_id: borrower.id,
      lender_id: lender.id,
      amount: 5000,
      interest: 5.0,
      purpose: "Medical Emergency",
      status: "pending",
      repayment_till: 30.days.from_now,
      expected_return: 5250
    }
  end

  let(:invalid_params) { { borrower_id: nil, lender_id: nil, amount: nil } } # Simplified for validation testing

  describe "#call" do
    context "when loan creation is successful" do
      it "creates and returns a loan" do
        service = LoanCreater.new(valid_params)
        loan = service.call

        expect(loan).to be_a(Loan)
        expect(loan.amount).to eq(5000)
        expect(loan.status).to eq("pending")
      end
    end

    context "when loan creation fails" do
      it "raises an error with validation messages" do
        service = LoanCreater.new(invalid_params)

        expect { service.call }.to raise_error(StandardError, /can't be blank/)
      end
    end
  end
end
