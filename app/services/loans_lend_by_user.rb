class LoansLendByUser
  def initialize(user)
    @user_id = user.id
  end

  def call
    @loans = Loan.where(lender_id: @user_id)
  end
end
