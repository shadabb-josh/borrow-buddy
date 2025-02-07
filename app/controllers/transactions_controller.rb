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
    @transaction = TransactionService.create_transaction(set_params)
    render json: @transaction, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private
    def set_params
      params.permit(:user_id, :loan_id, :amount, :transaction_type)
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("responses.transactions.not_found") }, status: :not_found
    end
end
