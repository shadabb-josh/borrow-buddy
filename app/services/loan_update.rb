class LoanUpdate
  def initialize(loan, loan_params)
    @loan = loan
    @loan_params = loan_params
  end

  def call
    return @loan if @loan.update(@loan_params)
    raise StandardError.new(user.errors.full_messages.join(", "))
  end
end
