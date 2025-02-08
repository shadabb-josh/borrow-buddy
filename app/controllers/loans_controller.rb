class LoansController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]
  before_action :set_loan, only: [ :show, :update, :destroy ]

  def index
    @loans = Loan.all
    render json: @loans, each_serializer: LoanSerializer, status: :ok
  end

  def show
    render json: @loan, serializer: LoanSerializer, status: :ok
  end

  def create
    @loan = LoanCreater.new(loan_params).create
    render json: @loan, serializer: LoanSerializer, status: :ok
  end

  def update
    loan = LoanUpdate.new(@loan, loan_params).update
    render json: loan, serializer: LoanSerializer, status: :ok
  end

  def destroy
    message = LoanDestroy.new(@loan).destroy
    render json: message, status: :ok
  end

  private

  def loan_params
    params.permit(:borrower_id, :lender_id, :amount, :interest, :purpose,
                  :status, :repayment_till, :expected_return)
  end

  def set_loan
    @loan = Loan.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t("responses.loans.not_found") }, status: :not_found
  end
end
