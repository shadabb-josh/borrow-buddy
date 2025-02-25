class LoanUpdate
  def initialize(loan, loan_params)
    @loan = loan
    @loan_params = loan_params
    @loan_status = loan_params[:status].to_i
    @borrower = User.find_by(id: @loan.borrower_id)
  end

  def call
    if @loan.update(@loan_params)
      send_mail_according_to_status(@borrower, @loan_status)
      @loan
    else
      raise StandardError, @loan.errors.full_messages.join(", ")
    end
  end

  private

  def send_mail_according_to_status(borrower, status)
    case status
    when 1
      UserMailer.loan_approved(borrower, "approved").deliver_later
    when 2
      UserMailer.loan_funded(borrower, "funded").deliver_later
    when 3
      UserMailer.loan_repaid(borrower, "repaid").deliver_later
    else
      UserMailer.loan_application_submit(borrower, "pending").deliver_later
    end
  end
end
