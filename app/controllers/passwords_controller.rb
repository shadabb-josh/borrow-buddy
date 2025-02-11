class PasswordsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :verify_otp, :reset_password ]
  before_action :set_user, only: [ :verify_otp, :reset_password ]

  def verify_otp
    if @user && @user.otp_valid?(params[:otp])
      render json: { message: I18n.t("otp.verified") }, status: :ok
    else
      render json: { message: I18n.t("otp.not_verified") }, status: :unprocessable_entity
    end
  end

  def reset_password
      @user.skip_validations = true
      if @user.update(password: params[:new_password])
        UserMailer.password_reset(@user).deliver_later
        @user.clear_otp
        render json: { message: I18n.t("user.password_reset_success") }, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
  end

  private

  def set_user
    @user = User.find_by(email: params[:email])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: I18n.t("user.not_found") }, status: :not_found
  end
end
