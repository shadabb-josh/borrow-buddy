class RepaymentCreator
  def initialize(repayment_params)
    @repayment_params = repayment_params
  end

  def create
    repayment = Repayment.new(@repayment_params)

    if repayment.save
      repayment
    else
      raise StandardError.new(repayment.errors.full_messages)
    end
  end
end
