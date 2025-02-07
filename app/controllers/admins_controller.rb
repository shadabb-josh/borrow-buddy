class AdminsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]
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
    @admin = AdminService.create_admin(admin_params)
    render json: @admin, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  # UPDATE /admins/{id}
  def update
    @admin = AdminService.update_admin(@admin, admin_params)
    render json: @admin, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  # DELETE /admins/{id}
  def destroy
    message = AdminService.delete_admin(@admin)
    render json: { message: message }, status: :ok
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def admin_params
    params.permit(:username, :password)
  end

  def set_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t("responses.admins.not_found") }, status: :not_found
  end
end
