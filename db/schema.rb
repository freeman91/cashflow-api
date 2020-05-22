# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191213165939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "debt_groups", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_debt_groups_on_account_id"
  end

  create_table "debts", force: :cascade do |t|
    t.bigint "account_id"
    t.float "amount", null: false
    t.string "group", null: false
    t.string "description"
    t.integer "cwmonth", null: false
    t.integer "cwyear", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_debts_on_account_id"
  end

  create_table "expense_groups", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_expense_groups_on_account_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "account_id"
    t.float "amount", null: false
    t.string "group", null: false
    t.string "vendor"
    t.string "description"
    t.boolean "bill", null: false
    t.integer "cwday"
    t.integer "cweek"
    t.integer "cwmonth", null: false
    t.integer "cwyear", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_expenses_on_account_id"
  end

  create_table "income_sources", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_income_sources_on_account_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "account_id"
    t.float "amount", null: false
    t.string "source", null: false
    t.string "description"
    t.integer "cwday", null: false
    t.integer "cweek", null: false
    t.integer "cwmonth", null: false
    t.integer "cwyear", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_incomes_on_account_id"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "account_id"
    t.float "amount", null: false
    t.string "source", null: false
    t.string "description"
    t.integer "cwmonth", null: false
    t.integer "cwyear", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_properties_on_account_id"
  end

  create_table "property_sources", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_property_sources_on_account_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "auth_token"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string "reset_password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_hours", force: :cascade do |t|
    t.bigint "account_id"
    t.float "amount", null: false
    t.string "source", null: false
    t.integer "cwday", null: false
    t.integer "cweek", null: false
    t.integer "cwmonth", null: false
    t.integer "cwyear", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_work_hours_on_account_id"
  end

  add_foreign_key "debt_groups", "accounts"
  add_foreign_key "debts", "accounts"
  add_foreign_key "expense_groups", "accounts"
  add_foreign_key "expenses", "accounts"
  add_foreign_key "income_sources", "accounts"
  add_foreign_key "incomes", "accounts"
  add_foreign_key "properties", "accounts"
  add_foreign_key "property_sources", "accounts"
  add_foreign_key "work_hours", "accounts"
end
