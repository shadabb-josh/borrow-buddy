class PlatformStats
  def call
    active_users = User.count
    in_active_users = User.where(status: "deactivate").count
    number_of_borrowers = Loan.select(:borrower_id).distinct.count
    number_of_lenders = Loan.select(:lender_id).distinct.count
    number_of_loan_applications = Loan.count
    number_of_loan_funded = Loan.where(status: 3).count
    number_of_loan_approved = Loan.where(status: 1).count
    number_of_loan_pending = Loan.where(status: 0).count
    number_of_loan_repaid = Loan.where(status: 2).count
    number_of_transactions = Transaction.count
    total_transaction_amount = Transaction.sum(:amount) / 2
    platform_revenue = Loan.sum(&:platform_fee)
    average_loan_amount = Loan.average(:amount)

    {
      active_users: active_users,
      in_active_users: in_active_users,
      number_of_borrowers: number_of_borrowers,
      number_of_lenders: number_of_lenders,
      number_of_loan_applications: number_of_loan_applications,
      number_of_loan_funded: number_of_loan_funded,
      number_of_loan_approved: number_of_loan_approved,
      number_of_loan_pending: number_of_loan_pending,
      number_of_loan_repaid: number_of_loan_repaid,
      number_of_transactions: number_of_transactions,
      total_transaction_amount: total_transaction_amount,
      platform_revenue: platform_revenue,
      average_loan_amount: average_loan_amount
    }
  end
end
