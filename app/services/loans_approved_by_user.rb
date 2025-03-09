class LoansApprovedByUser
  def initialize(user)
    @user_id = user.id
  end

  def call
    # status: 1 represents "approved"
    @loans = Loan.where(lender_id: @user_id, status: 1)
  end
end
