class RepaymentsController < ApplicationController
  before_action :set_repayment, only: [ :show ]

  def index
    @repayments = Repayment.all
    render json: @repayments, status: :ok
  end

  def show
    render json: @repayment, status: :ok
  end

  def create
    @repayment = RepaymentService.create_repayment(set_params)
    render json: @repayment, status: :ok
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private
    def set_params
      params.permit(:loan_id, :amount_paid)
    end

    def set_repayment
      @repayment = Repayment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("responses.repayments.not_found") }, status: :not_found
    end
end
