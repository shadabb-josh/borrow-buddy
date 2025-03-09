class OtpController < ApplicationController
  skip_before_action :authenticate_request, only: [ :send_otp ]
  before_action :set_user, only: [ :send_otp ]

  def send_otp
      UserMailer.send_otp(@user).deliver_now
      render json: { message: I18n.t("otp.sent") }
  end

  private
  def set_user
    @user = User.find_by(email: params[:email])
    unless @user
      render json: { errors: I18n.t("user.not_found") }, status: :unprocessable_entity
    end
  end
end
