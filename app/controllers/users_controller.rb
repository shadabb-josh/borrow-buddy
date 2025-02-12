class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create, :update ]
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
    sender = User.find(transaction_params[:sender_id])
    receiver = User.find(transaction_params[:receiver_id])
    amount = transaction_params[:amount]
    entered_pin = transaction_params[:entered_pin].to_s

    if sender.id == receiver.id
      return render json: { errors: "Sender and receiver cannot be the same" },
      status: :unprocessable_entity
    end

    if sender.status != "active" || receiver.status != "active"
      return render json: { errors: "Both accounts must be active" },
      status: :unprocessable_entity
    end

    if amount <= 0
      return render json: { errors: "Transaction amount must be positive" }, status: :unprocessable_entity
    end

    if sender.balance < amount
      return render json: { errors: "Insufficient balance" }, status: :unprocessable_entity
    end

    unless sender.authenticate_pin(entered_pin)
      return render json: { errors: "Invalid PIN" }, status: :unauthorized
    end

    ActiveRecord::Base.transaction do
      sender.update_columns(balance: sender.balance - amount)
      receiver.update_columns(balance: receiver.balance + amount)

      Transaction.create(user_id: sender.id, loan_id: 10, amount: amount, transaction_type: 2)
      Transaction.create(user_id: receiver.id, loan_id: 10, amount: amount, transaction_type: 0)
    end
    render json: { message: "Transaction Complete" }
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
    params.permit(:sender_id, :receiver_id, :amount, :entered_pin)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: I18n.t("user.not_found") }, status: :not_found
  end
end
