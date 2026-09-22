class PaymentsController < ApplicationController
  before_action :set_credit

  def new
    @payment = @credit.payments.new(payment_date: Date.current)
  end

  def create
    @payment = @credit.payments.new(payment_params)
    if @payment.save
      redirect_to credit_path(@credit), notice: "Abono de #{helpers.cop(@payment.amount)} registrado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @payment = @credit.payments.find(params[:id])
    @payment.destroy
    redirect_to credit_path(@credit), notice: "Abono eliminado.", status: :see_other
  end

  private

  def set_credit
    @credit = Credit.find(params[:credit_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_date, :amount, :payment_method, :note)
  end
end
