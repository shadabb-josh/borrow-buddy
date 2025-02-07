class LoansController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create ]
  before_action :set_loan, only: [ :show, :update, :destroy ]

  def index
    @loans = Loan.all
    render json: { loans: @loans }, each_serializer: LoanSerializer, status: :ok
  end

  def show
    render json: { loan: @loan }, serializer: LoanSerializer, status: :ok
  end

  def create
    @loan = LoanService.create_loan(loan_params)
    render json: { loan:  @loan }, serializer: LoanSerializer, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def update
    loan = LoanService.update_loan(@loan, loan_params)
    render json: { loan: loan }, serializer: LoanSerializer, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def destroy
    message = LoanService.delete_loan(@loan)
    render json: message, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
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
