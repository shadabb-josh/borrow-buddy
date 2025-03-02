require 'rails_helper'

RSpec.describe LoansLendByUser, type: :service do
  let(:lender) { create(:user) }
  let(:borrower) { create(:user) }

  let!(:loan_1) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :approved) }
  let!(:loan_2) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :funded) }
  let!(:other_lender_loan) { create(:loan, lender_id: create(:user).id, borrower_id: borrower.id, status: :approved) }

  describe "#call" do
    it "returns all loans lent by the given user" do
      service = LoansLendByUser.new(lender)
      result = service.call

      expect(result).to match_array([loan_1, loan_2])
    end

    it "does not return loans lent by other users" do
      service = LoansLendByUser.new(lender)
      result = service.call

      expect(result).not_to include(other_lender_loan)
    end

    it "returns an empty array if the user has not lent any loans" do
      new_lender = create(:user)
      service = LoansLendByUser.new(new_lender)
      result = service.call

      expect(result).to be_empty
    end
  end
end
