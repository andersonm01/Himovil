class Phone < ApplicationRecord
  MODELS = [
    "iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max",
    "iPhone 12", "iPhone 12 mini", "iPhone 12 Pro", "iPhone 12 Pro Max",
    "iPhone 13", "iPhone 13 mini", "iPhone 13 Pro", "iPhone 13 Pro Max",
    "iPhone 14", "iPhone 14 Plus", "iPhone 14 Pro", "iPhone 14 Pro Max",
    "iPhone 15", "iPhone 15 Plus", "iPhone 15 Pro", "iPhone 15 Pro Max",
    "iPhone 16", "iPhone 16 Plus", "iPhone 16 Pro", "iPhone 16 Pro Max",
    "iPhone 17", "iPhone 17 Pro", "iPhone 17 Pro Max"
  ].freeze

  CAPACITIES = [ "64 GB", "128 GB", "256 GB", "512 GB", "1 TB", "2 TB" ].freeze

  CONDITIONS = [
    "Nuevo sellado", "Como nuevo", "Usado - Muy bueno", "Usado - Bueno", "Usado - Con detalles"
  ].freeze

  SOURCES = [ "Compra", "Retoma", "Consignación", "Otro" ].freeze

  belongs_to :source_sale, class_name: "Sale", optional: true, inverse_of: :traded_in_phone
  has_one :sale, dependent: :nullify

  validates :entry_date, presence: true
  validates :model, presence: true
  validates :purchase_price, :repair_cost, :sale_price, numericality: { greater_than_or_equal_to: 0 }
  validates :battery_health, numericality: { in: 0..100 }, allow_nil: true

  scope :available, -> { where.missing(:sale) }
  scope :sold, -> { where.associated(:sale) }
  scope :demo_data, -> { where(demo: true) }

  scope :search, ->(term) {
    return all if term.blank?
    like = "%#{term}%"
    where("model ILIKE :q OR color ILIKE :q OR imei ILIKE :q OR supplier ILIKE :q", q: like)
  }

  def code
    "CEL-#{format('%03d', id)}"
  end

  def total_cost
    purchase_price.to_i + repair_cost.to_i
  end

  def expected_margin
    sale_price.to_i - total_cost
  end

  def margin_percent
    return 0 if total_cost.zero?
    ((expected_margin.to_f / total_cost) * 100).round(1)
  end

  def status
    sale.present? ? "Vendido" : "Disponible"
  end

  def available?
    sale.blank?
  end

  def days_in_inventory
    end_date = sale&.sale_date || Date.current
    (end_date - entry_date).to_i
  end

  def battery_low?
    battery_health.present? && battery_health < 80
  end

  def icloud_pending?
    icloud_account.present? && !icloud_unlocked?
  end

  def changed_parts
    parts = []
    parts << "Pantalla" if screen_replaced?
    parts << "Batería" if battery_replaced?
    parts << "Cámara" if camera_replaced?
    parts << "Face ID/Touch ID no funciona" unless face_id_touch_id_works?
    parts
  end
end
