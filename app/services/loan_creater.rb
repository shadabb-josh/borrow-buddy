class LoanCreater
  def initialize(loan_params)
    @loan_params = loan_params
  end

  def create
    loan = Loan.create(@loan_params)

    if loan.save
      loan
    else
      raise StandardError.new(loan.erros.full_messages.join(", "))
    end
  end
end
