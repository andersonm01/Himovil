class SalesController < ApplicationController
  before_action :set_sale, only: [ :show, :edit, :update, :destroy ]

  def index
    @sales = Sale.includes(:phone).order(sale_date: :desc, created_at: :desc)
    @sales = @sales.search(params[:q]) if params[:q].present?
    @sales = @sales.where(payment_method: params[:forma_pago]) if params[:forma_pago].present?
  end

  def show
  end

  def new
    @sale = Sale.new(sale_date: Date.current, warranty_days: 30, trade_in: false, down_payment: 0, trade_in_value: 0)
    @available_phones = Phone.available.order(:model)
  end

  def edit
    @available_phones = Phone.available.order(:model)
  end

  def create
    @sale = Sale.new(sale_params)
    if @sale.save
      redirect_to sales_path, notice: "Venta #{@sale.code} registrada."
    else
      @available_phones = Phone.available.order(:model)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sale.update(sale_params.except(
      :trade_in_model, :trade_in_storage_capacity, :trade_in_color, :trade_in_imei,
      :trade_in_condition, :trade_in_battery_health, :trade_in_icloud_account,
      :trade_in_icloud_unlocked, :trade_in_notes, :trade_in, :phone_id
    ))
      redirect_to sales_path, notice: "Venta #{@sale.code} actualizada."
    else
      @available_phones = Phone.available.order(:model)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    code = @sale.code
    @sale.destroy
    redirect_to sales_path, notice: "Venta #{code} eliminada.", status: :see_other
  end

  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :sale_date, :phone_id, :customer_name, :customer_id_number, :customer_phone,
      :customer_email, :sale_price, :payment_method, :financing_entity, :trade_in,
      :trade_in_value, :down_payment, :warranty_days, :notes,
      :trade_in_model, :trade_in_storage_capacity, :trade_in_color, :trade_in_imei,
      :trade_in_condition, :trade_in_battery_health, :trade_in_icloud_account,
      :trade_in_icloud_unlocked, :trade_in_notes
    )
  end
end
