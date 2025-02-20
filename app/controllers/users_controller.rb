class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]
  before_action :set_user, only: [ :show, :destroy, :update, :change_password ]

  # GET /users
  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer, status: :ok
  end

  # GET /users/{id}
  def show
    render json: @user, serializer: UserSerializer, status: :ok
  end

  # POST /users
  def create
    user = UserRegister.new(user_params).call
    render json: user, serializer: UserSerializer, status: :ok
  end

  # UPDATE /users/{id}
  def update
    user = UserUpdate.new(@user, user_params).call
    render json: user, serializer: UserSerializer, status: :ok
  end

  # DELETE /users/{id}
  def destroy
    message = UserDestroy.new(@user).call
    render json: message, status: :ok
  end

  # PATCH /users/change_password
  def change_password
    message = UserPasswordChange.new(@user, change_password_params).call
    render json: message, status: :ok
  end

  def do_transaction
    message = TransactionCreator.new(transaction_params).call
    render json: message, status: :ok
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password,
                  :pan_number, :adhaar_number, :status, :balance,
                  :account_number, :ifsc, :pin)
  end

  def change_password_params
    params.permit(:old_password, :new_password)
  end

  def transaction_params
    params.permit(:sender_id, :receiver_id, :amount, :entered_pin, :loan_id)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: I18n.t("user.not_found") }, status: :not_found
  end
end
