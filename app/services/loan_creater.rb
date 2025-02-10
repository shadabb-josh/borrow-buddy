class LoanCreater
  def initialize(loan_params)
    @loan_params = loan_params
  end

  def call
    loan = Loan.create(@loan_params)

    return loan if loan.save
    raise StandardError.new(loan.erros.full_messages.join(", "))
  end
end
