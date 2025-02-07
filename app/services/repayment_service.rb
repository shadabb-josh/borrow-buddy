class RepaymentService
  def create_repayment(params)
    repayment = Repayment.create(params)
    if repayment.persisted?
      repayment
    else
      raise StandardError.new(repayment.errors.full_messages)
    end
  end
end
