class CreditsController < ApplicationController
  before_action :set_credit, only: [ :show, :edit, :update ]

  def index
    @credits = Credit.includes(sale: :phone).order(created_at: :desc)
    @credits = @credits.where(status: params[:estado]) if params[:estado].present?
    @credits = @credits.where(entity: params[:entidad]) if params[:entidad].present?
    if params[:q].present?
      like = "%#{params[:q]}%"
      @credits = @credits.joins(:sale).where("sales.customer_name ILIKE :q", q: like)
    end
  end

  def show
  end

  def choose_payment
    @credits = Credit.active.includes(sale: :phone).order(created_at: :desc)
  end

  def edit
  end

  def update
    if @credit.update(credit_params)
      redirect_to credit_path(@credit), notice: "Crédito #{@credit.code} actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_credit
    @credit = Credit.find(params[:id])
  end

  def credit_params
    params.require(:credit).permit(:installments_count, :due_date)
  end
end
