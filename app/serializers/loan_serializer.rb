class LoanSerializer < ActiveModel::Serializer
  attributes :id, :borrower_id, :lender_id, :amount,
             :interest, :purpose, :repayment_till, :expected_return,
             :status, :total_return, :platform_fee

  # (Total Return Principle Amount + Interest) - Platform Fee
  def total_return
    object.calculate_returns(object.repayment_till, object.amount, object.interest, true) - platform_fee
  end

  # Interest on Principle Amount
  def expected_return
    object.calculate_returns(object.repayment_till, object.amount, object.interest)
  end

  # Platform fee per loan
  def platform_fee
    object.platform_fee
  end
end
