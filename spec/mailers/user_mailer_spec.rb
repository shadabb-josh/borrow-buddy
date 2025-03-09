require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, email: "test@example.com", first_name: "John", last_name: "Doe") }
  let(:receiver) { create(:user, first_name: "Jane", last_name: "Smith") }
  let(:lender) { create(:user) }
  let(:loan) { create(:loan, borrower: user) }
  let(:amount) { 1000 }
  let(:reason) { "Insufficient funds" }

  describe "welcome_email" do
    let(:mail) { described_class.welcome_email(user) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.welcome_subject"))
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([ user.email ])
    end
  end

  describe "send_otp" do
    before { allow(user).to receive(:generate_otp).and_return("123456") }
    let(:mail) { described_class.send_otp(user) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.reset_pass_subject"))
    end
  end

  describe "password_reset" do
    let(:mail) { described_class.password_reset(user) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.reset_pass_change_success_subject"))
    end
  end

  describe "transaction_success_for_sender" do
    let(:mail) { described_class.transaction_success_for_sender(user, amount, receiver) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.transaction_alert"))
    end
  end

  describe "transaction_success_for_reciever" do
    let(:mail) { described_class.transaction_success_for_reciever(receiver, amount, user) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.payment_recieved"))
    end
  end

  describe "transaction_failure_for_sender" do
    let(:mail) { described_class.transaction_failure_for_sender(user, amount, receiver, reason) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.transaction_failed"))
    end
  end

  describe "loan_application_submit" do
    let(:mail) { described_class.loan_application_submit(user, "pending") }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.loan_application_submit"))
    end
  end

  describe "loan_approved" do
    let(:mail) { described_class.loan_approved(user, "approved") }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.loan_approved"))
    end
  end

  describe "loan_funded" do
    let(:mail) { described_class.loan_funded(user, "funded") }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.loan_funded"))
    end
  end

  describe "loan_repaid" do
    let(:mail) { described_class.loan_repaid(user, "repaid") }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.loan_repaid"))
    end
  end

  describe "loan_repaid_for_lender" do
    let(:pdf_mock) { StringIO.new("fake_pdf_data") }

    before do
      allow(RepaymentPdfGenerator).to receive(:new).with(lender, loan).and_return(double(call: pdf_mock))
    end

    let(:mail) { described_class.loan_repaid_for_lender(lender, loan) }

    it "renders the subject" do
      expect(mail.subject).to eq(I18n.t("email.loan_repaid"))
    end

    it "attaches a PDF file" do
      expect(mail.attachments.size).to eq(1)
      expect(mail.attachments.first.filename).to eq("Repayment_Confirmation_Loan_#{loan.id}.pdf")
    end
  end
end
