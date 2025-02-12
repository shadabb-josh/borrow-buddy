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

ActiveRecord::Schema[7.2].define(version: 2025_02_12_090603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.integer "borrower_id"
    t.integer "lender_id"
    t.float "amount"
    t.float "interest"
    t.string "purpose"
    t.date "repayment_till"
    t.float "expected_return"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repayments", force: :cascade do |t|
    t.integer "loan_id"
    t.float "amount_paid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "loan_id"
    t.float "amount"
    t.integer "transaction_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "pan_number"
    t.string "adhaar_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.string "ifsc"
    t.string "pin_digest"
    t.decimal "balance"
  end

  add_foreign_key "loans", "users", column: "borrower_id"
  add_foreign_key "loans", "users", column: "lender_id"
  add_foreign_key "repayments", "loans"
  add_foreign_key "transactions", "loans"
  add_foreign_key "transactions", "users"
end
