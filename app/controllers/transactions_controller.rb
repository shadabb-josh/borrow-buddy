class TransactionsController < ApplicationController
  before_action :set_transaction, only: [ :show ]

  def index
    @transactions = Transaction.all
    render json: @transactions, status: :ok
  end

  def show
    render json: @transaction, status: :ok
  end

  def create
    @transaction = TransactionCreator.new(transaction_params).create
    render json: @transaction, status: :ok
  end

  private
    def transaction_params
      params.permit(:user_id, :loan_id, :amount, :transaction_type)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("responses.transactions.not_found") }, status: :not_found
    end
end
