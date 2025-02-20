class RepaymentCreator
  def initialize(transaction_params)
    @transaction_params = transaction_params
  end

  def call
    transaction_completed = TransactionCreator.new(@transaction_params).call(true)
    if transaction_completed
      Repayment.create(loan_id: @transaction_params[:loan_id], amount_paid: @transaction_params[:amount])
      { message: "Repayment Successfull" }
    end
  end
end
