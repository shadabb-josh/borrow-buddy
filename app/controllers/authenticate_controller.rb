class AuthenticateController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/admin-login
  def admin_login
    @admin = Admin.find_by(username: params[:username])

    if @admin.nil?
      return render json: { error: "username not found" }, status: :not_found
    end

    if @admin&.authenticate(params[:password])
      token = jwt_encode(admin_id: @admin.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "incorrect password" }, status: :unauthorized
    end
  end

  # POST /auth/user-login
  def user_login
    @user = User.find_by(email: params[:email])

    if @user.nil?
      return render json: { error: "email not found" }, status: :not_found
    end

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "incorrect password" }, status: :unauthorized
    end
  end
end
