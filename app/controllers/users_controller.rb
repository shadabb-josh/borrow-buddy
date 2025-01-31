class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create, :change_password ]
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

  # PATCH /users/change_password
  def change_password
    @user = User.find_by(email: change_password_params[:email])

    if @user.nil?
      return render json: { error: "email not found" }, status: :not_found
    end

    if @user.authenticate(change_password_params[:old_password])
      if @user.update(password: change_password_params[:new_password])
        render json: { message: "password changed successfully " }, status: :ok
      else
        render json: { message: "failed to change passeord" }, status: unprocessable
      end
    else
      render json: { error: "incorrect old password" }, status: unauthorized
    end
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :password, :pan_number, :adhaar_number, :status)
  end

  def change_password_params
    params.permit(:email, :old_password, :new_password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
