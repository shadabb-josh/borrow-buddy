class Loan < ApplicationRecord
  # Validations
  validates :borrower_id, :lender_id, :amount, :interest, :purpose, :repayment_till, :expected_return, :status, presence: true

  # Enum for loan status
  enum status: { pending: 0, approved: 1, funded: 3, repaid: 2 }
end
