class RepaymentCreator
  def initialize(transaction_params)
    @transaction_params = transaction_params
    @loan = Loan.find_by(lender_id: transaction_params[:receiver_id])
    @lender = User.find_by(id: transaction_params[:receiver_id])
  end

  def call
    transaction_completed = TransactionCreator.new(@transaction_params).call(true)
    if transaction_completed
      Repayment.create(loan_id: @transaction_params[:loan_id], amount_paid: @transaction_params[:amount])
      UserMailer.loan_repaid_for_lender(@lender, @loan).deliver_now
      { message: "Repayment Successfull" }
    end
  end
end
