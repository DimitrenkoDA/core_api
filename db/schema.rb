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

ActiveRecord::Schema[7.1].define(version: 2025_04_13_192048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.bigint "prev_authentication_id"
    t.string "step", null: false
    t.string "code"
    t.jsonb "props"
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_authentications_on_owner"
    t.index ["prev_authentication_id"], name: "index_authentications_on_prev_authentication_id"
    t.index ["step"], name: "index_authentications_on_step"
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "transaction_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_incomes_on_transaction_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "incomes_user_categories", id: false, force: :cascade do |t|
    t.bigint "income_id", null: false
    t.bigint "user_category_id", null: false
    t.index ["income_id", "user_category_id"], name: "idx_on_income_id_user_category_id_19467e368b", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "transaction_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_payments_on_transaction_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "payments_user_categories", id: false, force: :cascade do |t|
    t.bigint "payment_id", null: false
    t.bigint "user_category_id", null: false
    t.index ["payment_id", "user_category_id"], name: "idx_on_payment_id_user_category_id_cb153de776", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_categories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "kind", null: false
    t.string "colour_code", default: "#fff000", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_categories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.jsonb "balances", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "transactions", "users"
end
