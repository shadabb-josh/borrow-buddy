class RepaymentCreator
  def initialize(repayment_params)
    @repayment_params = repayment_params
  end

  def call
    repayment = Repayment.new(@repayment_params)

    return repayment if repayment.save
    raise StandardError.new(repayment.errors.full_messages)
  end
end
