class Loan < ApplicationRecord
  # Validations
  validates :borrower_id, :lender_id, :amount, :interest, :purpose, :repayment_till, :status, presence: true

  # Enum for loan status
  enum status: { pending: 0, approved: 1, funded: 3, repaid: 2 }

  def calculate_returns(repayment_till, amount, interest, include_principle = false)
    target_date = repayment_till
    current_date = Date.today
    days = (target_date - current_date)
    
    interest_amount = (amount * (interest / 100 / 365) * days).round(2)
    include_principle ? (amount + interest_amount).round(2) : interest_amount
  end
end
