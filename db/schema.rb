# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160522071025) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "owner_id"
    t.string   "subdomain"
    t.string   "stripe_customer_id"
    t.integer  "plan_id"
    t.string   "stripe_subscription_id"
    t.string   "stripe_subscription_status"
    t.index ["owner_id"], name: "index_accounts_on_owner_id", using: :btree
    t.index ["plan_id"], name: "index_accounts_on_plan_id", using: :btree
    t.index ["subdomain"], name: "index_accounts_on_subdomain", using: :btree
  end

  create_table "invitations", force: :cascade do |t|
    t.string   "email"
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "token"
    t.index ["account_id"], name: "index_invitations_on_account_id", using: :btree
    t.index ["token"], name: "index_invitations_on_token", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_memberships_on_account_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.integer  "amount"
    t.string   "stripe_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "websites_allowed"
  end

  create_table "subscription_events", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "type"
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.index ["account_id"], name: "index_subscription_events_on_account_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "websites", force: :cascade do |t|
    t.text     "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "account_id"
    t.index ["account_id"], name: "index_websites_on_account_id", using: :btree
  end

  add_foreign_key "accounts", "plans"
  add_foreign_key "invitations", "accounts"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "subscription_events", "accounts"
end
