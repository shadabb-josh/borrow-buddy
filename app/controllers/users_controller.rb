class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create, :index, :show ]
  before_action :set_user, only: [ :show, :destroy, :update, :change_password ]

  # GET /users
  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer,
    status: :ok
  end

  # GET /users/{id}
  def show
    render json: @user, serialize: UserSerializer,
    status: :ok
  end

  # POST /users
  def create
    @user = User.create(user_params)
    if @user.save
      render json: @user, serialize: UserSerializer,
      status: :ok
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # UPDATE /users/{id}
  def update
    if @user.update(user_params)
      render json: @user, serialize: UserSerializer,
      status: :ok
    end
    render json: { errors: @user.errors.full_messages },
           status: :unprocessable_entity
  end

  # DELETE /users/{id}
  def destroy
    if @user.destroy
      render json: { message: "User deleted successfully" },
             status: :ok
    else
      render json: { error: "Fail to delete user" },
             status: :unprocessable_entity
    end
  end

  # PATCH /users/change_password
  def change_password
    if @user.authenticate(change_password_params[:old_password])
      if @user.update(password: change_password_params[:new_password])
        render json: { message: "Password changed successfully" },
        status: :ok
      else
        render json: { message: "Failed to change passeord" },
        status: :unprocessable_entity
      end
    else
      render json: { message: "Incorrect old password" },
       status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :password,
                  :pan_number, :adhaar_number, :status)
  end

  def change_password_params
    params.permit(:old_password, :new_password)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
end
