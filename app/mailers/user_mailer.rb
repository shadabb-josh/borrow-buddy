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
end
