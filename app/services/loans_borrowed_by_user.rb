class LoansBorrowedByUser
  def initialize(user)
    @user_id = user.id
  end

  def call
    @loans = Loan.where(borrower_id: @user_id)
  end
end
