class LoansLendByUser
  def initialize(user)
    @user_id = user.id
  end

  def all_lended_loans
    @loans = Loan.where(lender_id: @user_id)
  end
end
