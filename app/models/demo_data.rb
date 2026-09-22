class DemoData
  def self.load!
    return if Phone.demo_data.exists? || Sale.demo_data.exists?

    phone1 = Phone.create!(
      entry_date: 20.days.ago.to_date,
      model: "iPhone 13 Pro",
      storage_capacity: "256 GB",
      color: "Grafito",
      imei: "352099001761481",
      condition: "Como nuevo",
      battery_health: 89,
      screen_replaced: false,
      battery_replaced: false,
      camera_replaced: false,
      face_id_touch_id_works: true,
      icloud_account: "cliente.demo@icloud.com",
      icloud_unlocked: true,
      source: "Compra",
      supplier: "Cliente particular",
      purchase_price: 1_800_000,
      repair_cost: 0,
      sale_price: 2_450_000,
      notes: "Equipo de ejemplo, incluye cargador original.",
      demo: true
    )

    Phone.create!(
      entry_date: 10.days.ago.to_date,
      model: "iPhone 12",
      storage_capacity: "128 GB",
      color: "Azul",
      imei: "352099001761499",
      condition: "Usado - Bueno",
      battery_health: 84,
      screen_replaced: true,
      battery_replaced: false,
      camera_replaced: false,
      face_id_touch_id_works: true,
      icloud_account: "",
      icloud_unlocked: true,
      source: "Compra",
      supplier: "Distribuidor Los Andes",
      purchase_price: 1_200_000,
      repair_cost: 80_000,
      sale_price: 1_650_000,
      notes: "Se le cambió la pantalla por una original.",
      demo: true
    )

    sale = Sale.create!(
      sale_date: 6.days.ago.to_date,
      phone: phone1,
      customer_name: "Juan Camilo Pérez",
      customer_id_number: "1020304050",
      customer_phone: "3011234567",
      customer_email: "juan.perez@example.com",
      sale_price: 2_450_000,
      payment_method: "Financiado",
      financing_entity: "Addi",
      trade_in: true,
      trade_in_value: 900_000,
      down_payment: 300_000,
      warranty_days: 30,
      notes: "Cliente frecuente, entrega en el punto de venta.",
      trade_in_model: "iPhone 11",
      trade_in_storage_capacity: "64 GB",
      trade_in_color: "Negro",
      trade_in_imei: "352099001761555",
      trade_in_condition: "Usado - Bueno",
      trade_in_battery_health: 81,
      trade_in_icloud_account: "",
      trade_in_icloud_unlocked: "1",
      trade_in_notes: "Recibido como parte de pago.",
      demo: true
    )

    sale.credit.payments.create!(
      payment_date: 2.days.ago.to_date,
      amount: 300_000,
      payment_method: "Nequi",
      note: "Primer abono de ejemplo."
    )
  end

  def self.clear!
    Sale.demo_data.find_each(&:destroy)
    Phone.demo_data.find_each(&:destroy)
  end
end
