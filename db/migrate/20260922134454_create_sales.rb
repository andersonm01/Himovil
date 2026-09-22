class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.date :sale_date, null: false
      t.references :phone, null: false, foreign_key: true
      t.string :customer_name, null: false
      t.string :customer_id_number
      t.string :customer_phone
      t.string :customer_email
      t.integer :sale_price, default: 0, null: false
      t.string :payment_method
      t.string :financing_entity
      t.boolean :trade_in, default: false, null: false
      t.integer :trade_in_value, default: 0, null: false
      t.integer :down_payment, default: 0, null: false
      t.integer :warranty_days, default: 0, null: false
      t.text :notes
      t.boolean :demo, default: false, null: false

      t.timestamps
    end
  end
end
