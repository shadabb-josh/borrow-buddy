require 'rails_helper'

RSpec.describe RepaymentCreator, type: :service do
  let(:lender) { create(:user) }
  let(:borrower) { create(:user) }
  let(:loan) { create(:loan, lender_id: lender.id) }
  let(:transaction_params) do
    {
      receiver_id: lender.id,
      loan_id: loan.id,
      amount: 1000
    }
  end

  subject { described_class.new(transaction_params) }

  describe "#call" do
    context "when transaction is successful" do
      before do
        allow_any_instance_of(TransactionCreator).to receive(:call).with(true).and_return(true)
      end

      it "creates a repayment record" do
        expect { subject.call }.to change { Repayment.count }.by(1)
      end

      it "sends an email to the lender" do
        expect(UserMailer).to receive(:loan_repaid_for_lender).with(lender, loan).and_call_original
        subject.call
      end

      it "returns a success message" do
        result = subject.call
        expect(result).to eq({ message: "Repayment Successfull" })
      end
    end

    context "when transaction fails" do
      before do
        allow_any_instance_of(TransactionCreator).to receive(:call).with(true).and_return(false)
      end

      it "does not create a repayment record" do
        expect { subject.call }.not_to change { Repayment.count }
      end

      it "does not send an email" do
        expect(UserMailer).not_to receive(:loan_repaid_for_lender)
        subject.call
      end
    end
  end
end
