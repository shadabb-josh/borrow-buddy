class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create, :index, :show, :destroy, :update ]
  before_action :set_user, only: [ :show, :destroy, :update ]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{id}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.create(user_params)
    if @user.save
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # UPDATE /users/{id}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{id}
  def destroy
    @user.destroy
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :password, :pan_number, :adhaar_number, :status)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
