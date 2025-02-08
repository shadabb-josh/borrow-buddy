class LoanDestroy
  def initialize(loan)
    @loan = loan
  end

  def destroy
    if @loan.destroy
      { 'message': I18n.t("responses.loans.deleted") }
    else
      raise StandardError.new(user.errors.full_messages.join(", "))
    end
  end
end
