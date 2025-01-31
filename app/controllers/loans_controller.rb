class LoansController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]
  before_action :set_loan, only: [ :show, :update, :destroy ]

  def index
    @loans = Loan.all
    render json: @loans, status: :ok
  end

  def show
    render json: @loan, status: :ok
  end

  def create
    @loan = Loan.create(set_params)
    if @loan.save
      render json: @loan, status: :ok
    else
      render json: { errors: @loan.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @loan.update(set_params)
      render json: @loan, status: :ok
    end
      render json: { errors: @loan.errors.full_messages },
             status: :unprocessable_entity
  end

  def destroy
    if @loan.destroy
      render json: { message: "Loan deleted sucessfully" },
             status: :ok
    else
      render json: { message: "Fail to delete loan" },
             status: :unprocessable_entity
    end
  end

  private
    def set_params
      params.permit(:borrower_id, :lender_id, :amount, :interest, :purpose, :status, :repayment_till, :expected_return)
    end

    def set_loan
      @loan = Loan.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Loan not found" }, status: :not_found
    end
end
