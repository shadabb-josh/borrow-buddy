class TransactionsController < ApplicationController
  before_action :set_repayment, only: [ :show ]

  def index
    @transactions = Transaction.all
    render json: @transactions, status: :ok
  end

  def show
    render json: @transaction, status: :ok
  end

  def create
    @transaction = Transaction.create(set_params)
    if @transaction.save
      render json: @transaction, status: :ok
    else
      render json: { errors: @transaction.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private
    def set_params
      params.permit(:user_id, :loan_id, :amount, :transaction_type)
    end

    def set_repayment
      @transaction = Transaction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render josn: { error: "Transaction not found" }, status: :not_found
    end
end
