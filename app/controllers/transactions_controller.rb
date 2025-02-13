class TransactionsController < ApplicationController
  before_action :set_transaction, only: [ :show ]

  def index
    @transactions = Transaction.all
    render json: @transactions, status: :ok
  end

  def show
    render json: @transaction, status: :ok
  end

  private

    def set_transaction
      @transaction = Transaction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("transaction.not_found") }, status: :not_found
    end
end
