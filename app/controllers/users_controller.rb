class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create, :index, :show]
  before_action :set_user, only: [ :show, :destroy, :update, :change_password ]

  # GET /users
  def index
    @users = User.all
    render json: @users , each_serializer: UserSerializer, status: :ok
  end

  # GET /users/{id}
  def show
    render json: @user , serializer: UserSerializer, status: :ok
  end

  # POST /users
  def create
    @user = UserService.create_user(user_params)
    render json: @user, serializer: UserSerializer, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  # UPDATE /users/{id}
  def update
    user = UserService.update_user(@user, user_params)
    render json: user, serializer: UserSerializer, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  # DELETE /users/{id}
  def destroy
    message = UserService.delete_user(@user)
    render json: message, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  # PATCH /users/change_password
  def change_password
    message = UserService.change_password(@user, change_password_params)
    render json: message, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
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
    render json: { errors: I18n.t("responses.users.not_found") }, status: :not_found
  end
end
