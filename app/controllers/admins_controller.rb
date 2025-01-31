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
    @admin = Admin.create(user_params)
    if @admin.save
      render json: @admin, status: :ok
    else
      render json: { errors: @admin.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # UPDATE /admins/{id}
  def update
    if @admin.update(user_params)
      render json: @admin, status: :ok
    end
      render json: { errors: @admin.errors.full_messages },
             status: :unprocessable_entity
  end

  # DELETE /admins/{id}
  def destroy
    if @admin.destroy
      render json: { message: "Admin deleted successfully" },
      status: :ok
    else
      render json: { message: "Fail to delete admin" },
      status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:username, :password)
    end

    def set_admin
      @admin = Admin.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Admin not found" }, status: :not_found
    end
end
