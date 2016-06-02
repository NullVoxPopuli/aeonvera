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

ActiveRecord::Schema.define(version: 20160602191847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendance_line_items", force: :cascade do |t|
    t.integer "attendance_id",  null: false
    t.integer "line_item_id",   null: false
    t.integer "quantity"
    t.string  "size"
    t.string  "line_item_type"
  end

  add_index "attendance_line_items", ["attendance_id", "line_item_id"], name: "index_attendance_line_items_on_attendance_id_and_line_item_id", using: :btree

  create_table "attendances", force: :cascade do |t|
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
    t.boolean  "attending",                              default: true, null: false
    t.string   "dance_orientation",          limit: 255
    t.string   "host_type",                  limit: 255
    t.string   "attendance_type",            limit: 255
    t.string   "transferred_to_name"
    t.integer  "transferred_to_user_id"
    t.datetime "transferred_at"
    t.string   "transfer_reason"
  end

  add_index "attendances", ["host_id", "host_type", "attendance_type"], name: "index_attendances_on_host_id_and_host_type_and_attendance_type", using: :btree
  add_index "attendances", ["host_id", "host_type"], name: "index_attendances_on_host_id_and_host_type", using: :btree

  create_table "attendances_discounts", force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "discount_id"
  end

  create_table "attendances_shirts", force: :cascade do |t|
    t.integer "attendance_id"
    t.integer "shirt_id"
  end

  create_table "attendees", force: :cascade do |t|
    t.string   "first_name",                 limit: 255
    t.string   "last_name",                  limit: 255
    t.string   "phone_number",               limit: 255
    t.integer  "dancer_orientation"
    t.boolean  "interested_in_volunteering"
    t.integer  "event_id"
    t.integer  "package_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "collaborated_id"
    t.string   "title",             limit: 255
    t.text     "permissions"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "collaborated_type", limit: 255
  end

  create_table "competition_responses", force: :cascade do |t|
    t.integer  "attendance_id"
    t.integer  "competition_id"
    t.string   "dance_orientation", limit: 255
    t.string   "partner_name",      limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attendance_type",   limit: 255, default: "EventAttendance"
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.integer  "kind",                          null: false
    t.text     "metadata"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "custom_field_responses", force: :cascade do |t|
    t.text     "value"
    t.integer  "writer_id"
    t.string   "writer_type",     limit: 255
    t.integer  "custom_field_id",             null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string   "label",         limit: 255
    t.integer  "kind"
    t.text     "default_value"
    t.boolean  "editable",                  default: true, null: false
    t.integer  "host_id"
    t.string   "host_type",     limit: 255
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounted_items", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.decimal  "value"
    t.integer  "kind"
    t.boolean  "disabled",                           default: false
    t.string   "affects",                limit: 255
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "allowed_number_of_uses"
    t.string   "host_type",              limit: 255
    t.string   "discount_type",          limit: 255
    t.boolean  "requires_student_id",                default: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",                            limit: 255,                 null: false
    t.string   "short_description",               limit: 255
    t.string   "domain",                          limit: 255,                 null: false
    t.datetime "starts_at",                                                   null: false
    t.datetime "ends_at",                                                     null: false
    t.datetime "mail_payments_end_at"
    t.datetime "electronic_payments_end_at"
    t.datetime "refunds_end_at"
    t.boolean  "has_volunteers",                              default: false, null: false
    t.string   "volunteer_description",           limit: 255
    t.integer  "housing_status",                              default: 0,     null: false
    t.string   "housing_nights",                  limit: 255, default: "5,6"
    t.integer  "hosted_by_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_discounts",                             default: true,  null: false
    t.string   "payment_email",                   limit: 255, default: "",    null: false
    t.boolean  "beta",                                        default: false, null: false
    t.datetime "shirt_sales_end_at"
    t.datetime "show_at_the_door_prices_at"
    t.boolean  "allow_combined_discounts",                    default: true,  null: false
    t.string   "location",                        limit: 255
    t.boolean  "show_on_public_calendar",                     default: true,  null: false
    t.boolean  "make_attendees_pay_fees",                     default: true,  null: false
    t.boolean  "accept_only_electronic_payments",             default: false, null: false
    t.string   "logo_file_name",                  limit: 255
    t.string   "logo_content_type",               limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "registration_email_disclaimer"
    t.boolean  "legacy_housing",                              default: false, null: false
    t.boolean  "ask_if_leading_or_following",                 default: true,  null: false
    t.string   "contact_email"
  end

  add_index "events", ["domain"], name: "index_events_on_domain", using: :btree

  create_table "external_payments", force: :cascade do |t|
    t.integer  "amount"
    t.boolean  "complete",                        default: false, null: false
    t.text     "metadata"
    t.integer  "event_id",                                        null: false
    t.integer  "attendance_id",                                   null: false
    t.datetime "payment_received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payer_id",            limit: 255
    t.string   "payment_id",          limit: 255
  end

  create_table "housing_provisions", force: :cascade do |t|
    t.integer  "housing_capacity"
    t.integer  "number_of_showers"
    t.boolean  "can_provide_transportation",             default: false, null: false
    t.integer  "transportation_capacity",                default: 0,     null: false
    t.string   "preferred_gender_to_host",   limit: 255
    t.boolean  "has_pets",                               default: false, null: false
    t.boolean  "smokes",                                 default: false, null: false
    t.text     "notes"
    t.integer  "attendance_id"
    t.string   "attendance_type",            limit: 255
    t.integer  "host_id"
    t.string   "host_type",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "housing_requests", force: :cascade do |t|
    t.boolean  "need_transportation"
    t.boolean  "can_provide_transportation",                 default: false, null: false
    t.integer  "transportation_capacity",                    default: 0,     null: false
    t.boolean  "allergic_to_pets",                           default: false, null: false
    t.boolean  "allergic_to_smoke",                          default: false, null: false
    t.string   "other_allergies",                limit: 255
    t.text     "requested_roommates"
    t.text     "unwanted_roommates"
    t.string   "preferred_gender_to_house_with", limit: 255
    t.text     "notes"
    t.integer  "attendance_id"
    t.string   "attendance_type",                limit: 255
    t.integer  "host_id"
    t.string   "host_type",                      limit: 255
    t.integer  "housing_provision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integrations", force: :cascade do |t|
    t.string  "kind",             limit: 255
    t.text    "encrypted_config"
    t.integer "owner_id"
    t.string  "owner_type",       limit: 255
  end

  add_index "integrations", ["owner_id", "owner_type"], name: "index_integrations_on_owner_id_and_owner_type", using: :btree

  create_table "levels", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "sequence"
    t.integer  "requirement"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "line_items", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.decimal  "price"
    t.integer  "host_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_type",              limit: 255
    t.string   "picture_file_name",      limit: 255
    t.string   "picture_content_type",   limit: 255
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "reference_id"
    t.text     "metadata"
    t.datetime "expires_at"
    t.string   "host_type",              limit: 255
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

  create_table "membership_renewals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "membership_option_id"
    t.datetime "start_date"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_line_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "line_item_id"
    t.string   "line_item_type",    limit: 255
    t.decimal  "price",                         default: 0.0, null: false
    t.integer  "quantity",                      default: 1,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "size"
    t.string   "color"
    t.string   "dance_orientation"
    t.string   "partner_name"
  end

  add_index "order_line_items", ["line_item_id", "line_item_type"], name: "index_order_line_items_on_line_item_id_and_line_item_type", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "payment_token",       limit: 255
    t.string   "payer_id",            limit: 255
    t.text     "metadata"
    t.integer  "attendance_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",                            default: false,  null: false
    t.string   "payment_method",      limit: 255, default: "Cash", null: false
    t.decimal  "paid_amount"
    t.decimal  "net_amount_received",             default: 0.0,    null: false
    t.decimal  "total_fee_amount",                default: 0.0,    null: false
    t.integer  "user_id"
    t.string   "host_type",           limit: 255
    t.datetime "payment_received_at"
  end

  add_index "orders", ["host_id", "host_type"], name: "index_orders_on_host_id_and_host_type", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "tagline",                    limit: 255
    t.string   "city",                       limit: 255
    t.string   "state",                      limit: 255
    t.boolean  "beta",                                   default: false, null: false
    t.integer  "owner_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain",                     limit: 255
    t.boolean  "make_attendees_pay_fees"
    t.string   "logo_file_name",             limit: 255
    t.string   "logo_content_type",          limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "notify_email"
    t.boolean  "email_all_purchases",                    default: false, null: false
    t.boolean  "email_membership_purchases",             default: false, null: false
    t.string   "contact_email"
  end

  add_index "organizations", ["domain"], name: "index_organizations_on_domain", using: :btree

  create_table "packages", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.integer  "attendee_limit"
    t.datetime "expires_at"
    t.boolean  "requires_track"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "ignore_pricing_tiers",             default: false, null: false
  end

  add_index "packages", ["event_id"], name: "index_packages_on_event_id", using: :btree

  create_table "packages_pricing_tiers", force: :cascade do |t|
    t.integer "package_id"
    t.integer "pricing_tier_id"
  end

  create_table "passes", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "intended_for",      limit: 255
    t.integer  "percent_off"
    t.integer  "discountable_id"
    t.string   "discountable_type", limit: 255
    t.integer  "attendance_id"
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pricing_tiers", force: :cascade do |t|
    t.decimal  "increase_by_dollars", default: 0.0
    t.datetime "date"
    t.integer  "registrants"
    t.integer  "event_id"
    t.datetime "deleted_at"
  end

  create_table "raffles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "event_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
  end

  create_table "restraints", force: :cascade do |t|
    t.integer "dependable_id"
    t.string  "dependable_type",   limit: 255
    t.integer "restrictable_id"
    t.string  "restrictable_type", limit: 255
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shirts", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.string   "sizes",             limit: 255
    t.datetime "expires_at"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "time_zone",              limit: 255
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
