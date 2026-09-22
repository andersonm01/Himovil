class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :credit, null: false, foreign_key: true
      t.date :payment_date, null: false
      t.integer :amount, default: 0, null: false
      t.string :payment_method
      t.text :note

      t.timestamps
    end
  end
end
