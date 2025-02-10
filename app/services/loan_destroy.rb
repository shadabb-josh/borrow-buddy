class LoanDestroy
  def initialize(loan)
    @loan = loan
  end

  def call
    return success_message if @loan.destroy
    raise StandardError.new(user.errors.full_messages.join(", "))
  end

  private

  def success_message
    { 'message': I18n.t("loan.deleted") }
  end
end
