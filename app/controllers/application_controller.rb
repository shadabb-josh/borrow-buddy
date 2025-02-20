class ApplicationController < ActionController::API
  include JsonWebToken

  rescue_from StandardError, with: :handle_standard_error
  before_action :authenticate_request

  private
    def authenticate_request
      header = request.headers["Authorization"]
      token = header.split(" ").last if header
      decoded = jwt_decode(token)

      if decoded[:admin_id]
        @current_admin = Admin.find_by(id: decoded[:admin_id])
      elsif decoded[:user_id]
        @current_user = User.find_by(id: decoded[:user_id])
      end
    end

    def handle_standard_error(exception)
      render json: { errors: exception.message }, status: :unprocessable_entity
    end
end
