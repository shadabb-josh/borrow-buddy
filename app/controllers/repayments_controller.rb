class RepaymentsController < ApplicationController
  before_action :set_repayment, only: [ :show ]

  def index
    @repayments = Repayment.all
    render json: @repayments, status: :ok
  end

  def show
    render json: @repayment, status: :ok
  end

  private

    def set_repayment
      @repayment = Repayment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t("responses.repayments.not_found") }, status: :not_found
    end
end
