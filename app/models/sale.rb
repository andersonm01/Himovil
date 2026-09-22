class Sale < ApplicationRecord
  PAYMENT_METHODS = [ "Contado", "Financiado", "Fiado - crédito propio", "Mixto" ].freeze
  FINANCING_ENTITIES = [ "N/A", "Addi", "Sistecrédito", "Banco", "Crédito propio", "Otra" ].freeze

  belongs_to :phone
  has_one :credit, dependent: :destroy
  has_one :traded_in_phone, class_name: "Phone", foreign_key: :source_sale_id, dependent: :nullify, inverse_of: :source_sale

  attr_accessor :trade_in_model, :trade_in_storage_capacity, :trade_in_color, :trade_in_imei,
                :trade_in_condition, :trade_in_battery_health, :trade_in_icloud_account,
                :trade_in_icloud_unlocked, :trade_in_notes

  validates :sale_date, presence: true
  validates :phone, presence: true
  validates :customer_name, presence: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_method, inclusion: { in: PAYMENT_METHODS }, allow_blank: true

  validate :phone_must_be_available, on: :create
  validate :phone_icloud_must_be_released, on: :create

  scope :demo_data, -> { where(demo: true) }
  scope :this_month, -> { where(sale_date: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :search, ->(term) {
    return all if term.blank?
    like = "%#{term}%"
    joins(:phone).where(
      "sales.customer_name ILIKE :q OR sales.customer_id_number ILIKE :q OR sales.customer_phone ILIKE :q OR phones.model ILIKE :q OR phones.imei ILIKE :q",
      q: like
    )
  }

  after_create :create_traded_in_phone_if_needed
  after_create :create_credit_if_needed

  def code
    "V-#{format('%03d', id)}"
  end

  def financed_balance
    [ sale_price.to_i - trade_in_value.to_i - down_payment.to_i, 0 ].max
  end

  def equipment_cost
    phone&.total_cost.to_i
  end

  def profit
    sale_price.to_i - equipment_cost
  end

  def warranty_end_date
    return nil if warranty_days.blank? || warranty_days.to_i <= 0
    sale_date + warranty_days.to_i.days
  end

  def customer_whatsapp_number
    digits = customer_phone.to_s.gsub(/\D/, "")
    return nil if digits.blank?
    digits.start_with?("57") ? digits : "57#{digits.sub(/\A0+/, '')}"
  end

  private

  def phone_must_be_available
    return if phone_id.blank?
    already_sold = Sale.where(phone_id: phone_id).where.not(id: id).exists?
    errors.add(:phone_id, "ya fue vendido, selecciona otro celular disponible") if already_sold
  end

  def phone_icloud_must_be_released
    return if phone.blank?
    errors.add(:base, "No se puede vender este celular: el iCloud / Apple ID no ha sido liberado") if phone.icloud_pending?
  end

  def create_traded_in_phone_if_needed
    return unless trade_in? && trade_in_model.present?

    Phone.create!(
      entry_date: sale_date,
      model: trade_in_model,
      storage_capacity: trade_in_storage_capacity,
      color: trade_in_color,
      imei: trade_in_imei,
      condition: trade_in_condition,
      battery_health: trade_in_battery_health.presence,
      icloud_account: trade_in_icloud_account,
      icloud_unlocked: ActiveModel::Type::Boolean.new.cast(trade_in_icloud_unlocked),
      source: "Retoma",
      supplier: customer_name,
      purchase_price: trade_in_value.to_i,
      repair_cost: 0,
      sale_price: 0,
      notes: trade_in_notes,
      source_sale_id: id,
      demo: demo
    )
  end

  def create_credit_if_needed
    return if financed_balance <= 0
    create_credit!(
      entity: financing_entity.presence || "N/A",
      initial_balance: financed_balance,
      status: "Activo"
    )
  end
end
