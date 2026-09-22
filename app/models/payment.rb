class Payment < ApplicationRecord
  METHODS = [ "Efectivo", "Transferencia", "Nequi", "Daviplata", "Tarjeta", "Otro" ].freeze

  belongs_to :credit

  validates :payment_date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  after_save :sync_credit_status
  after_destroy :sync_credit_status

  private

  def sync_credit_status
    credit.recalculate_status!
  end
end
