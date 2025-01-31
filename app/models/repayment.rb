class Repayment < ApplicationRecord
  validates :loan_id, :amount_paid, presence: true
end
