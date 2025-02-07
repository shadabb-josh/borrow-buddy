class LoanService
  def self.create_loan(params)
    loan = Loan.create(params)
    if loan.persisted?
      loan
    else
      raise StandardError.new(loan.errors.full_messages.join(", "))
    end
  end

  def self.update_loan(loan, params)
    if loan.update(params)
      loan
    else
      raise StandardError.new(loan.errors.full_messages.join(", "))
    end
  end

  def self.delete_loan(loan)
    if loan.destroy
      { message: I18n.t("responses.loans.deleted") }
    else
      raise StandardError.new(loan.errors.full_messages.join(", "))
    end
  end
end
