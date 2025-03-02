class Repayment < ApplicationRecord
  # Associations
  belongs_to :loan

  # Validations
  validates :loan_id, :amount_paid, presence: true
end
