# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_04_02_221000) do

  create_table "guests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.integer "restaurant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "notes"
    t.text "allergies"
    t.json "metadata"
    t.string "full_name"
  end

  create_table "opening_times", force: :cascade do |t|
    t.integer "day_of_week"
    t.string "opening_time"
    t.string "closing_time"
    t.integer "restaurant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "status"
    t.datetime "start_time"
    t.integer "covers"
    t.string "notes"
    t.integer "restaurant_id"
    t.integer "guest_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "qr_code_image"
    t.text "hash_id"
    t.string "table"
    t.json "metadata"
    t.boolean "confirmation_request", default: false
    t.datetime "confirmation_request_date"
    t.index ["hash_id"], name: "index_reservations_on_hash_id", unique: true
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.text "cuisines"
    t.string "phone"
    t.string "email"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "channel_phone_id"
    t.text "channel_token"
    t.text "channel_number"
    t.text "tenant_id"
    t.json "reservations_contacts"
    t.json "metadata"
    t.boolean "send_confirmation", default: false
    t.integer "send_confirmation_before", default: 24
    t.text "confirmation_header_text", default: "Please confirm your reservation"
    t.text "confirmation_body_text", default: "We're looking forward to seeing you. Please confirm your reservation by replying YES."
  end

  create_table "sections", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.string "name"
    t.text "description"
    t.integer "capacity"
    t.json "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_id"], name: "index_sections_on_restaurant_id"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.string "name"
    t.string "section"
    t.integer "capacity"
    t.integer "position_x"
    t.integer "position_y"
    t.json "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_id"], name: "index_tables_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "authentication_token", limit: 30
    t.integer "restaurant_id"
    t.boolean "active", default: true
    t.string "name"
    t.string "job"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
  end

  add_foreign_key "sections", "restaurants"
  add_foreign_key "tables", "restaurants"
  add_foreign_key "users", "restaurants"
end
