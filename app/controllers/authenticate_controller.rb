class AuthenticateController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/login
  def login
    @admin = Admin.find_by(username: params[:username])

    if @admin&.authenticate(params[:password])
      token = jwt_encode(admin_id: @admin.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end
end
