class PhonesController < ApplicationController
  before_action :set_phone, only: [ :show, :edit, :update, :destroy ]

  def index
    @phones = Phone.includes(:sale).order(created_at: :desc)
    @phones = @phones.search(params[:q]) if params[:q].present?
    @phones = @phones.available if params[:estado] == "Disponible"
    @phones = @phones.sold if params[:estado] == "Vendido"
    @phones = @phones.where(condition: params[:condicion]) if params[:condicion].present?
  end

  def show
    redirect_to edit_phone_path(@phone)
  end

  def new
    @phone = Phone.new(entry_date: Date.current, icloud_unlocked: true, face_id_touch_id_works: true)
  end

  def edit
  end

  def create
    @phone = Phone.new(phone_params)
    if @phone.save
      redirect_to phones_path, notice: "Celular #{@phone.code} agregado al inventario."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @phone.update(phone_params)
      redirect_to phones_path, notice: "Celular #{@phone.code} actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    code = @phone.code
    @phone.destroy
    redirect_to phones_path, notice: "Celular #{code} eliminado.", status: :see_other
  end

  private

  def set_phone
    @phone = Phone.find(params[:id])
  end

  def phone_params
    params.require(:phone).permit(
      :entry_date, :model, :storage_capacity, :color, :imei, :condition,
      :battery_health, :screen_replaced, :battery_replaced, :camera_replaced,
      :face_id_touch_id_works, :other_details, :icloud_account, :icloud_unlocked,
      :source, :supplier, :purchase_price, :repair_cost, :sale_price, :notes
    )
  end
end
