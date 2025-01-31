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
    @repayment = Repayment.create(set_params)
    if @repayment.save
      render json: @repayment, status: :ok
    else
      render json: { errors: @repayment.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private
    def set_params
      params.permit(:loan_id, :amount_paid)
    end

    def set_repayment
      @repayment = Repayment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render josn: { error: "repayment not found" }, status: :not_found
    end
end
