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
    @repayment = RepaymentCreator.new(repayment_params).create
    render json: @repayment, status: :ok
  end

  private
    def repayment_params
      params.permit(:loan_id, :amount_paid)
    end

    def set_repayment
      @repayment = Repayment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("responses.repayments.not_found") }, status: :not_found
    end
end
