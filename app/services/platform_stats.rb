class PlatformStats
  def call
    active_users = User.count
    in_active_users = User.where(status: "deactivate").count
    number_of_transactions = Transaction.count
    total_transaction_amount = Transaction.sum(:amount) / 2
    platform_revenue = Loan.sum(&:platform_fee)

    query = "
              COUNT(DISTINCT loans.borrower_id) AS number_of_borrowers,
              COUNT(DISTINCT loans.lender_id) AS number_of_lenders,
              COUNT(loans.id) AS number_of_loans_applications,
              COUNT(CASE WHEN loans.status = 0 THEN 1 END) AS number_of_loans_pending,
              COUNT(CASE WHEN loans.status = 1 THEN 1 END) AS number_of_loans_approved,
              COUNT(CASE WHEN loans.status = 2 THEN 1 END) AS number_of_loans_funded,
              COUNT(CASE WHEN loans.status = 3 THEN 1 END) AS number_of_loans_repaid,
              AVG(loans.amount) AS average_total_amount
            "

    loan_data = Loan.select(query).to_a.first
    {
      active_users: active_users,
      in_active_users: in_active_users,
      number_of_borrowers: loan_data.number_of_borrowers,
      number_of_lenders: loan_data.number_of_lenders,
      number_of_loan_applications: loan_data.number_of_loans_applications,
      number_of_loan_funded: loan_data.number_of_loans_funded,
      number_of_loan_approved: loan_data.number_of_loans_approved,
      number_of_loan_pending: loan_data.number_of_loans_pending,
      number_of_loan_repaid: loan_data.number_of_loans_repaid,
      number_of_transactions: number_of_transactions,
      total_transaction_amount: total_transaction_amount,
      platform_revenue: platform_revenue,
      average_loan_amount: loan_data.average_total_amount
    }
  end
end
