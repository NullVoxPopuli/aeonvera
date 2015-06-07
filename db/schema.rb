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

ActiveRecord::Schema.define(version: 20150606040128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendance_line_items", force: true do |t|
    t.integer "attendance_id", null: false
    t.integer "line_item_id",  null: false
    t.integer "quantity"
  end

  add_index "attendance_line_items", ["attendance_id", "line_item_id"], name: "index_attendance_line_items_on_attendance_id_and_line_item_id", using: :btree

  create_table "attendances", force: true do |t|
    t.integer  "attendee_id"
    t.integer  "host_id"
    t.integer  "level_id"
    t.integer  "package_id"
    t.integer  "pricing_tier_id"
    t.boolean  "interested_in_volunteering"
    t.boolean  "needs_housing"
    t.boolean  "providing_housing"
    t.text     "metadata"
    t.datetime "checked_in_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "attending",                  default: true, null: false
    t.string   "dance_orientation"
    t.string   "host_type"
    t.string   "attendance_type"
  end

  add_index "attendances", ["host_id", "host_type", "attendance_type"], name: "index_attendances_on_host_id_and_host_type_and_attendance_type", using: :btree
  add_index "attendances", ["host_id", "host_type"], name: "index_attendances_on_host_id_and_host_type", using: :btree

  create_table "attendances_discounts", force: true do |t|
    t.integer "attendance_id"
    t.integer "discount_id"
  end

  create_table "attendances_shirts", force: true do |t|
    t.integer "attendance_id"
    t.integer "shirt_id"
  end

  create_table "attendees", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.integer  "dancer_orientation"
    t.boolean  "interested_in_volunteering"
    t.integer  "event_id"
    t.integer  "package_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", force: true do |t|
    t.integer  "user_id"
    t.integer  "collaborated_id"
    t.string   "title"
    t.text     "permissions"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "collaborated_type"
  end

  create_table "competition_responses", force: true do |t|
    t.integer  "attendance_id"
    t.integer  "competition_id"
    t.string   "dance_orientation"
    t.string   "partner_name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attendance_type",   default: "EventAttendance"
  end

  create_table "competitions", force: true do |t|
    t.string   "name"
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.integer  "kind",              null: false
    t.text     "metadata"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "custom_field_responses", force: true do |t|
    t.text     "value"
    t.integer  "writer_id"
    t.string   "writer_type"
    t.integer  "custom_field_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_fields", force: true do |t|
    t.string   "label"
    t.integer  "kind"
    t.text     "default_value"
    t.boolean  "editable",      default: true, null: false
    t.integer  "host_id"
    t.string   "host_type"
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounted_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", force: true do |t|
    t.string   "name"
    t.decimal  "value"
    t.integer  "kind"
    t.boolean  "disabled",               default: false
    t.string   "affects"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "allowed_number_of_uses"
    t.string   "host_type"
    t.string   "discount_type"
  end

  create_table "events", force: true do |t|
    t.string   "name",                                            null: false
    t.string   "short_description"
    t.string   "domain",                                          null: false
    t.datetime "starts_at",                                       null: false
    t.datetime "ends_at",                                         null: false
    t.datetime "mail_payments_end_at"
    t.datetime "electronic_payments_end_at"
    t.datetime "refunds_end_at"
    t.boolean  "has_volunteers",                  default: false, null: false
    t.string   "volunteer_description"
    t.integer  "housing_status",                  default: 0,     null: false
    t.string   "housing_nights",                  default: "5,6"
    t.integer  "hosted_by_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_discounts",                 default: true,  null: false
    t.string   "payment_email",                   default: "",    null: false
    t.boolean  "beta",                            default: false, null: false
    t.datetime "shirt_sales_end_at"
    t.datetime "show_at_the_door_prices_at"
    t.boolean  "allow_combined_discounts",        default: true,  null: false
    t.string   "location"
    t.boolean  "show_on_public_calendar",         default: true,  null: false
    t.boolean  "make_attendees_pay_fees",         default: true,  null: false
    t.boolean  "accept_only_electronic_payments", default: false, null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "registration_email_disclaimer"
    t.boolean  "legacy_housing",                  default: false, null: false
  end

  add_index "events", ["domain"], name: "index_events_on_domain", using: :btree

  create_table "external_payments", force: true do |t|
    t.integer  "amount"
    t.boolean  "complete",            default: false, null: false
    t.text     "metadata"
    t.integer  "event_id",                            null: false
    t.integer  "attendance_id",                       null: false
    t.datetime "payment_received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payer_id"
    t.string   "payment_id"
  end

  create_table "housing_provisions", force: true do |t|
    t.integer  "housing_capacity"
    t.integer  "number_of_showers"
    t.boolean  "can_provide_transportation", default: false, null: false
    t.integer  "transportation_capacity",    default: 0,     null: false
    t.string   "preferred_gender_to_host"
    t.boolean  "has_pets",                   default: false, null: false
    t.boolean  "smokes",                     default: false, null: false
    t.text     "notes"
    t.integer  "attendance_id"
    t.string   "attendance_type"
    t.integer  "host_id"
    t.string   "host_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "housing_requests", force: true do |t|
    t.boolean  "need_transportation"
    t.boolean  "can_provide_transportation",     default: false, null: false
    t.integer  "transportation_capacity",        default: 0,     null: false
    t.boolean  "allergic_to_pets",               default: false, null: false
    t.boolean  "allergic_to_smoke",              default: false, null: false
    t.string   "other_allergies"
    t.text     "requested_roommates"
    t.text     "unwanted_roommates"
    t.string   "preferred_gender_to_house_with"
    t.text     "notes"
    t.integer  "attendance_id"
    t.string   "attendance_type"
    t.integer  "host_id"
    t.string   "host_type"
    t.integer  "housing_provision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integrations", force: true do |t|
    t.string  "kind"
    t.text    "encrypted_config"
    t.integer "owner_id"
    t.string  "owner_type"
  end

  add_index "integrations", ["owner_id", "owner_type"], name: "index_integrations_on_owner_id_and_owner_type", using: :btree

  create_table "levels", force: true do |t|
    t.string   "name"
    t.integer  "sequence"
    t.integer  "requirement"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "line_items", force: true do |t|
    t.string   "name"
    t.decimal  "price"
    t.integer  "host_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_type"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "reference_id"
    t.text     "metadata"
    t.datetime "expires_at"
    t.string   "host_type"
    t.text     "description"
    t.text     "schedule"
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "duration_amount"
    t.integer  "duration_unit"
    t.datetime "registration_opens_at"
    t.datetime "registration_closes_at"
    t.datetime "becomes_available_at"
  end

  add_index "line_items", ["host_id", "host_type", "item_type"], name: "index_line_items_on_host_id_and_host_type_and_item_type", using: :btree
  add_index "line_items", ["host_id", "host_type"], name: "index_line_items_on_host_id_and_host_type", using: :btree

  create_table "membership_renewals", force: true do |t|
    t.integer  "user_id"
    t.integer  "membership_option_id"
    t.datetime "start_date"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "line_item_id"
    t.string   "line_item_type"
    t.decimal  "price",          default: 0.0, null: false
    t.integer  "quantity",       default: 1,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_line_items", ["line_item_id", "line_item_type"], name: "index_order_line_items_on_line_item_id_and_line_item_type", using: :btree

  create_table "orders", force: true do |t|
    t.string   "payment_token"
    t.string   "payer_id"
    t.text     "metadata"
    t.integer  "attendance_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",                default: false,  null: false
    t.string   "payment_method",      default: "Cash", null: false
    t.decimal  "paid_amount"
    t.decimal  "net_amount_received", default: 0.0,    null: false
    t.decimal  "total_fee_amount",    default: 0.0,    null: false
    t.integer  "user_id"
    t.string   "host_type"
  end

  add_index "orders", ["host_id", "host_type"], name: "index_orders_on_host_id_and_host_type", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "tagline"
    t.string   "city"
    t.string   "state"
    t.boolean  "beta",                    default: false, null: false
    t.integer  "owner_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
    t.boolean  "make_attendees_pay_fees"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "organizations", ["domain"], name: "index_organizations_on_domain", using: :btree

  create_table "packages", force: true do |t|
    t.string   "name"
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.integer  "attendee_limit"
    t.datetime "expires_at"
    t.boolean  "requires_track"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "ignore_pricing_tiers", default: false, null: false
  end

  add_index "packages", ["event_id"], name: "index_packages_on_event_id", using: :btree

  create_table "packages_pricing_tiers", force: true do |t|
    t.integer "package_id"
    t.integer "pricing_tier_id"
  end

  create_table "passes", force: true do |t|
    t.string   "name"
    t.string   "intended_for"
    t.integer  "percent_off"
    t.integer  "discountable_id"
    t.string   "discountable_type"
    t.integer  "attendance_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pricing_tiers", force: true do |t|
    t.decimal  "increase_by_dollars", default: 0.0
    t.datetime "date"
    t.integer  "registrants"
    t.integer  "event_id"
    t.datetime "deleted_at"
  end

  create_table "raffles", force: true do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
  end

  create_table "restraints", force: true do |t|
    t.integer "dependable_id"
    t.string  "dependable_type"
    t.integer "restrictable_id"
    t.string  "restrictable_type"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shirts", force: true do |t|
    t.string   "name"
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.string   "sizes"
    t.datetime "expires_at"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "time_zone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
