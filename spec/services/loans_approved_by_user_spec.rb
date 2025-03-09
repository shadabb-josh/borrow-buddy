require 'rails_helper'

RSpec.describe LoansApprovedByUser, type: :service do
  let(:lender) { create(:user) }
  let(:borrower) { create(:user) }

  let!(:approved_loan_1) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :approved) }
  let!(:approved_loan_2) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :approved) }
  let!(:pending_loan) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :pending) }
  let!(:other_lender_loan) { create(:loan, lender_id: create(:user).id, borrower_id: borrower.id, status: :approved) }

  describe "#call" do
    it "returns only approved loans for the given lender" do
      service = LoansApprovedByUser.new(lender)
      result = service.call

      expect(result).to match_array([approved_loan_1, approved_loan_2])
    end

    it "does not return pending or other lender's loans" do
      service = LoansApprovedByUser.new(lender)
      result = service.call

      expect(result).not_to include(pending_loan, other_lender_loan)
    end

    it "returns an empty array if the lender has no approved loans" do
      new_lender = create(:user)
      service = LoansApprovedByUser.new(new_lender)
      result = service.call

      expect(result).to be_empty
    end
  end
end
