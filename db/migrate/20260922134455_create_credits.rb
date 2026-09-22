class CreateCredits < ActiveRecord::Migration[8.1]
  def change
    create_table :credits do |t|
      t.references :sale, null: false, foreign_key: true
      t.string :entity
      t.integer :initial_balance, default: 0, null: false
      t.integer :installments_count
      t.date :due_date
      t.string :status, default: "Activo", null: false

      t.timestamps
    end
  end
end
