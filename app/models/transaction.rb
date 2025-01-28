class Transaction < ApplicationRecord
  # Validations
  validates :user_id, :loan_id, :amount, :transaction_type, presence: true
  # Enum for transaction type
  enum transaction_type: { deposit: 0, withdrawal: 1, investment: 2, repayment: 3 }
end
