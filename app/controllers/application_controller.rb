class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  private
    def authenticate_request
      header = request.headers["Authorization"]
      token = header.split(" ").last if header
      decoded = jwt_decode(token)

      if decoded[:admin_id]
        @current_admin = Admin.find(id: decoded[:admin_id])
      elsif decoded[:user_id]
        @current_user = User.find(id: decoded[:user_id])
      end
    end
end
