class Repayment < ApplicationRecord
  validates :loan_id, :amount_paid, :paid_at, presence: true
end
