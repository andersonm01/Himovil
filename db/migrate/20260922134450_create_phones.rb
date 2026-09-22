class CreatePhones < ActiveRecord::Migration[8.1]
  def change
    create_table :phones do |t|
      t.date :entry_date, null: false
      t.string :model, null: false
      t.string :storage_capacity
      t.string :color
      t.string :imei
      t.string :condition
      t.integer :battery_health
      t.boolean :screen_replaced, default: false, null: false
      t.boolean :battery_replaced, default: false, null: false
      t.boolean :camera_replaced, default: false, null: false
      t.boolean :face_id_touch_id_works, default: true, null: false
      t.text :other_details
      t.string :icloud_account
      t.boolean :icloud_unlocked, default: true, null: false
      t.string :source
      t.string :supplier
      t.integer :purchase_price, default: 0, null: false
      t.integer :repair_cost, default: 0, null: false
      t.integer :sale_price, default: 0, null: false
      t.text :notes
      t.references :source_sale, index: true
      t.boolean :demo, default: false, null: false

      t.timestamps
    end
  end
end
