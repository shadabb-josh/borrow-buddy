class AuthenticateController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/admin-login
  def admin_login
    @admin = Admin.find_by(username: params[:username])

    if @admin.nil?
      return render json: { error: I18n.t("responses.admins.not_found") }, status: :not_found
    end

    if @admin&.authenticate(params[:password])
      token = jwt_encode(admin_id: @admin.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: I18n.t("responses.admins.incorrect_password") }, status: :unauthorized
    end
  end

  # POST /auth/user-login
  def user_login
    @user = User.find_by(email: params[:email])

    if @user.nil?
      return render json: { error: "responses.users.email_not_found" }, status: :not_found
    end

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: I18n.t("responses.users.incorrect_password") }, status: :unauthorized
    end
  end
end
