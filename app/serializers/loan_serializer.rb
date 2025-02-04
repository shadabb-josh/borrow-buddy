class LoanSerializer < ActiveModel::Serializer
  attributes :id, :borrower_id, :lender_id, :amount,
             :interest, :purpose, :repayment_till, :expected_return,
             :status, :total_return

  # Total Return Principle Amount + Interest
  def total_return
    target_date = object.repayment_till
    current_date = Date.today
    days = (target_date - current_date)
    object.amount + (object.amount * (0.12/365) * days).round(2)
  end
end
