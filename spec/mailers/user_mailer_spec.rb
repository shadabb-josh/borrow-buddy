require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, email: "test@example.com", first_name: "John", last_name: "Doe") }
  let(:recipient) { create(:user, email: "recipient@example.com", first_name: "Jane", last_name: "Smith") }
  let(:loan) { create(:loan, id: 123, borrower: user) }

  describe "welcome_email" do
    let(:mail) { described_class.welcome_email(user).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("email.welcome_subject"))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end
  end

  describe "send_otp" do
    let(:mail) { described_class.send_otp(user).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("email.reset_pass_subject"))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])  # Ensured consistency
    end
  end

  describe "transaction_success_for_sender" do
    let(:mail) { described_class.transaction_success_for_sender(user, 500, recipient).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("email.transaction_alert"))
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])  # Ensured consistency
    end
  end

  describe "loan_repaid_for_lender" do
    let(:lender) { create(:user, email: "lender@example.com") }
    let(:mail) { described_class.loan_repaid_for_lender(lender, loan).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("email.loan_repaid"))
      expect(mail.to).to eq([lender.email])
      expect(mail.from).to eq(["from@example.com"])  # Ensured consistency
    end

    it "attaches repayment PDF" do
      expect(mail.attachments.count).to eq(1)
      expect(mail.attachments.first.filename).to eq("Repayment_Confirmation_Loan_#{loan.id}.pdf")
    end
  end
end
