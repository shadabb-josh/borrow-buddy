require 'rails_helper'

RSpec.describe LoansBorrowedByUser, type: :service do
  let(:borrower) { create(:user) }
  let(:lender) { create(:user) }

  let!(:loan_1) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :approved) }
  let!(:loan_2) { create(:loan, lender_id: lender.id, borrower_id: borrower.id, status: :funded) }
  let!(:other_borrower_loan) { create(:loan, lender_id: lender.id, borrower_id: create(:user).id, status: :approved) }

  describe "#call" do
    it "returns all loans borrowed by the given user" do
      service = LoansBorrowedByUser.new(borrower)
      result = service.call

      expect(result).to match_array([loan_1, loan_2])
    end

    it "does not return loans borrowed by other users" do
      service = LoansBorrowedByUser.new(borrower)
      result = service.call

      expect(result).not_to include(other_borrower_loan)
    end

    it "returns an empty array if the user has not borrowed any loans" do
      new_borrower = create(:user)
      service = LoansBorrowedByUser.new(new_borrower)
      result = service.call

      expect(result).to be_empty
    end
  end
end
