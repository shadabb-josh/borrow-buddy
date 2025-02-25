class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("email.welcome_subject"))
  end

  def send_otp(user)
    @user = user
    @otp = user.generate_otp
    mail(to: @user.email, subject: I18n.t("email.reset_pass_subject"))
  end

  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("email.reset_pass_change_success_subject"))
  end

  def transaction_success_for_sender(sender, amount, receiver)
    @sender = sender
    @amount = amount
    @recipient_name = "#{receiver.first_name} #{receiver.last_name}"

    mail(to: @sender.email, subject: I18n.t("email.transaction_alert"))
  end


  def transaction_success_for_reciever(recipient, amount, sender)
    @recipient = recipient
    @amount = amount
    @sender_name = "#{sender.first_name} #{sender.last_name}"

    mail(to: @recipient.email, subject: I18n.t("email.payment_recieved"))
  end

  def transaction_failure_for_sender(sender, amount, receiver, reason)
    @sender = sender
    @amount = amount
    @recipient_name = "#{receiver.first_name} #{receiver.last_name}"
    @reason = reason

    mail(to: @sender.email, subject: I18n.t("email.transaction_failed"))
  end

  def loan_application_submit(borrower, status)
    @borrower = borrower
    @status = status
    mail(to: @borrower.email, subject: I18n.t("email.loan_application_submit"))
  end

  def loan_approved(borrower, status)
    @borrower = borrower
    @status = status
    mail(to: @borrower.email, subject: I18n.t("email.loan_approved"))
  end

  def loan_funded(borrower, status)
    @borrower = borrower
    @status = status
    mail(to: @borrower.email, subject: I18n.t("email.loan_funded"))
  end

  def loan_repaid(borrower, status)
    @borrower = borrower
    @status = status
    mail(to: @borrower.email, subject: I18n.t("email.loan_repaid"))
  end

  def loan_repaid_for_lender(lender, loan)
    @lender = lender
    @loan = loan
    mail(to: @lender.email, subject: I18n.t("email.loan_repaid"))
  end
end
