class LoansBorrowedByUser
  def initialize(user)
    @user_id = user.id
  end

  def all_borrowed_loans
    @loans = Loan.where(borrower_id: @user_id)
  end
end
