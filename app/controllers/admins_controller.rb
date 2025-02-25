class AdminsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create, :platform_stats ]
  before_action :set_admin, only: [ :show, :destroy, :update ]

  # GET /admins
  def index
    @admins = Admin.all
    render json: @admins, status: :ok
  end

  # GET /admins/{id}
  def show
    render json: @admin, status: :ok
  end

  # POST /admins
  def create
    @admin = AdminRegister.new(admin_params).call
    render json: @admin, status: :ok
  end

  # UPDATE /admins/{id}
  def update
    @admin = AdminUpdate.new(admin_params).call
    render json: @admin, status: :ok
  end

  # DELETE /admins/{id}
  def destroy
    message = AdminDestroy.new(admin_params).call
    render json: { message: message }, status: :ok
  end

  def platform_stats
    stats = PlatformStats.new.call
    render json: stats
  end

  private

  def admin_params
    params.permit(:username, :password)
  end

  def set_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t("admin.not_found") }, status: :not_found
  end
end
