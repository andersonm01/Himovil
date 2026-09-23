class Credit < ApplicationRecord
  STATUSES = [ "Activo", "Pagado" ].freeze

  belongs_to :sale
  has_many :payments, dependent: :destroy

  validates :initial_balance, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }

  scope :demo_data, -> { joins(:sale).where(sales: { demo: true }) }
  scope :active, -> { where(status: "Activo") }
  scope :own_credit, -> { where(entity: "Crédito propio") }

  delegate :customer_name, :customer_phone, :phone, to: :sale, prefix: false

  def code
    "CR-#{format('%03d', id)}"
  end

  def total_paid
    # Block form reuses preloaded `payments` (via .includes) with no extra
    # query; payments.sum(:amount) would always hit the database.
    payments.sum(&:amount)
  end

  def pending_balance
    [ initial_balance.to_i - total_paid, 0 ].max
  end

  def progress_percent
    return 100 if initial_balance.to_i.zero?
    ((total_paid.to_f / initial_balance) * 100).clamp(0, 100).round
  end

  def paid?
    status == "Pagado"
  end

  def overdue?
    !paid? && due_date.present? && due_date < Date.current
  end

  def recalculate_status!
    new_status = pending_balance <= 0 ? "Pagado" : "Activo"
    update_column(:status, new_status) if status != new_status
  end

  def whatsapp_reminder_message
    "Hola #{customer_name}, te escribimos de tu tienda de celulares por el crédito #{code}. " \
    "Tienes un saldo pendiente de #{ActionController::Base.helpers.number_to_currency(pending_balance, unit: '$', precision: 0, delimiter: '.', separator: ',', format: '%u%n', negative_format: '-%u%n')}" \
    "#{due_date.present? ? ", con fecha de pago el #{due_date.strftime('%d/%m/%Y')}" : ''}. " \
    "¿Podrías confirmarnos cuándo realizarás el abono? ¡Gracias!"
  end
end
