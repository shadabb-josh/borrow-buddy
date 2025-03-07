class LoanDistribution
  def call
    Loan.group(:purpose).count
  end
end
