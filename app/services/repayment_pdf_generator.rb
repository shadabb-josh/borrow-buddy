require "prawn"
require "prawn/table"

class RepaymentPdfGenerator
  def initialize(lender, loan)
    @lender = lender
    @loan = loan
  end

  def generate
    Prawn::Document.new do |pdf|
      pdf.text "Loan Repayment Confirmation", size: 18, style: :bold
      pdf.move_down 10

      pdf.text "Dear #{@lender.first_name},"
      pdf.move_down 10
      pdf.text "We are pleased to inform you that Loan ID ##{@loan.id} has been successfully repaid."
      pdf.move_down 10

      pdf.table([
        [ "Loan Amount", "Rs.#{@loan.amount}" ],
        [ "Expected Return", "Rs.#{@loan.expected_return}" ],
        [ "Platform Fee", "Rs.#{@loan.platform_fee}" ],
        [ "Total Return (After Fee)", "Rs.#{@loan.total_return}" ]
      ], header: true, cell_style: { padding: 8, borders: [ :bottom ] })

      pdf.move_down 10
      pdf.text "The repayment has been credited to your account. Thank you for using BorrowBuddy."

      pdf.move_down 20
      pdf.text "Best regards,", style: :italic
      pdf.text "The BorrowBuddy Team"
    end.render
  end
end
