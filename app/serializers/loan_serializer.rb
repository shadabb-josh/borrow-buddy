class LoanSerializer < ActiveModel::Serializer
  attributes :id, :borrower_id, :lender_id, :amount,
             :interest, :purpose, :repayment_till, :expected_return,
             :status, :total_return

  # Total Return Principle Amount + Interest
  def total_return
    object.calculate_returns(object.repayment_till, object.amount, object.interest, true)
  end

  # Interest on Principle Amount
  def expected_return
    object.calculate_returns(object.repayment_till, object.amount, object.interest)
  end
end
