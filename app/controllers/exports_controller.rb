require "csv"

class ExportsController < ApplicationController
  def phones
    csv = CSV.generate(headers: true) do |rows|
      rows << [
        "Código", "Fecha ingreso", "Modelo", "Capacidad", "Color", "IMEI", "Condición",
        "Batería %", "Pantalla cambiada", "Batería cambiada", "Cámara cambiada",
        "Face/Touch ID funciona", "Otras piezas o detalles", "iCloud / Apple ID", "iCloud liberado",
        "Origen", "Comprado a / Proveedor", "Precio entrada", "Gastos reparación", "Precio venta",
        "Costo total", "Margen esperado", "Margen %", "Estado", "Días en inventario", "Notas"
      ]
      Phone.order(:id).each do |p|
        rows << [
          p.code, p.entry_date, p.model, p.storage_capacity, p.color, p.imei, p.condition,
          p.battery_health, si_no(p.screen_replaced), si_no(p.battery_replaced), si_no(p.camera_replaced),
          si_no(p.face_id_touch_id_works), p.other_details, p.icloud_account, si_no(p.icloud_unlocked),
          p.source, p.supplier, p.purchase_price, p.repair_cost, p.sale_price,
          p.total_cost, p.expected_margin, p.margin_percent, p.status, p.days_in_inventory, p.notes
        ]
      end
    end
    send_csv csv, "inventario.csv"
  end

  def sales
    csv = CSV.generate(headers: true) do |rows|
      rows << [
        "Código", "Fecha", "Celular", "Cliente", "Cédula", "Teléfono", "Email", "Precio venta",
        "Forma de pago", "Entidad", "Retoma", "Valor retoma", "Cuota inicial", "Saldo financiado",
        "Costo equipo", "Ganancia", "Garantía (días)", "Fin garantía", "Notas"
      ]
      Sale.order(:id).each do |s|
        rows << [
          s.code, s.sale_date, s.phone&.code, s.customer_name, s.customer_id_number, s.customer_phone,
          s.customer_email, s.sale_price, s.payment_method, s.financing_entity, si_no(s.trade_in),
          s.trade_in_value, s.down_payment, s.financed_balance, s.equipment_cost, s.profit,
          s.warranty_days, s.warranty_end_date, s.notes
        ]
      end
    end
    send_csv csv, "ventas.csv"
  end

  def credits
    csv = CSV.generate(headers: true) do |rows|
      rows << [
        "Código", "Cliente", "Celular", "Entidad", "Saldo inicial", "Total abonado",
        "Saldo pendiente", "Cuotas", "Fecha de pago", "Estado", "Atrasado"
      ]
      Credit.order(:id).each do |c|
        rows << [
          c.code, c.customer_name, c.phone&.code, c.entity, c.initial_balance, c.total_paid,
          c.pending_balance, c.installments_count, c.due_date, c.status, si_no(c.overdue?)
        ]
      end
    end
    send_csv csv, "creditos.csv"
  end

  def payments
    csv = CSV.generate(headers: true) do |rows|
      rows << [ "Crédito", "Cliente", "Fecha", "Valor", "Método de pago", "Nota" ]
      Payment.includes(credit: :sale).order(:id).each do |p|
        rows << [ p.credit.code, p.credit.customer_name, p.payment_date, p.amount, p.payment_method, p.note ]
      end
    end
    send_csv csv, "abonos.csv"
  end

  private

  def si_no(value)
    value ? "Sí" : "No"
  end

  def send_csv(csv, filename)
    send_data csv, filename: filename, type: "text/csv"
  end
end
