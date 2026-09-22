# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_22_140605) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "credits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "due_date"
    t.string "entity"
    t.integer "initial_balance", default: 0, null: false
    t.integer "installments_count"
    t.integer "sale_id", null: false
    t.string "status", default: "Activo", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_credits_on_sale_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "credit_id", null: false
    t.text "note"
    t.date "payment_date", null: false
    t.string "payment_method"
    t.datetime "updated_at", null: false
    t.index ["credit_id"], name: "index_payments_on_credit_id"
  end

  create_table "phones", force: :cascade do |t|
    t.integer "battery_health"
    t.boolean "battery_replaced", default: false, null: false
    t.boolean "camera_replaced", default: false, null: false
    t.string "color"
    t.string "condition"
    t.datetime "created_at", null: false
    t.boolean "demo", default: false, null: false
    t.date "entry_date", null: false
    t.boolean "face_id_touch_id_works", default: true, null: false
    t.string "icloud_account"
    t.boolean "icloud_unlocked", default: true, null: false
    t.string "imei"
    t.string "model", null: false
    t.text "notes"
    t.text "other_details"
    t.integer "purchase_price", default: 0, null: false
    t.integer "repair_cost", default: 0, null: false
    t.integer "sale_price", default: 0, null: false
    t.boolean "screen_replaced", default: false, null: false
    t.string "source"
    t.integer "source_sale_id"
    t.string "storage_capacity"
    t.string "supplier"
    t.datetime "updated_at", null: false
    t.index ["source_sale_id"], name: "index_phones_on_source_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_email"
    t.string "customer_id_number"
    t.string "customer_name", null: false
    t.string "customer_phone"
    t.boolean "demo", default: false, null: false
    t.integer "down_payment", default: 0, null: false
    t.string "financing_entity"
    t.text "notes"
    t.string "payment_method"
    t.integer "phone_id", null: false
    t.date "sale_date", null: false
    t.integer "sale_price", default: 0, null: false
    t.boolean "trade_in", default: false, null: false
    t.integer "trade_in_value", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "warranty_days", default: 0, null: false
    t.index ["phone_id"], name: "index_sales_on_phone_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "credits", "sales"
  add_foreign_key "payments", "credits"
  add_foreign_key "sales", "phones"
  add_foreign_key "sessions", "users"
end
