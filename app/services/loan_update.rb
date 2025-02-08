class LoanUpdate
  def initialize(loan, loan_params)
    @loan = loan
    @loan_params = loan_params
  end

  def update
    if @loan.update(@loan_params)
      @loan
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end
end
