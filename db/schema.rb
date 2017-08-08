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

ActiveRecord::Schema.define(version: 20170804101456) do

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

  add_index "collaborations", ["collaborated_id", "collaborated_type"], name: "index_collaborations_on_collaborated_id_and_collaborated_type", using: :btree
  add_index "collaborations", ["user_id"], name: "index_collaborations_on_user_id", using: :btree

  create_table "competitions", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.decimal  "initial_price"
    t.decimal  "at_the_door_price"
    t.integer  "kind",                                          null: false
    t.text     "metadata"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "description"
    t.boolean  "nonregisterable",               default: false, null: false
  end

  add_index "competitions", ["event_id"], name: "index_competitions_on_event_id", using: :btree

  create_table "custom_field_responses", force: :cascade do |t|
    t.text     "value"
    t.integer  "writer_id"
    t.string   "writer_type",     limit: 255
    t.integer  "custom_field_id",             null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_field_responses", ["writer_id", "writer_type"], name: "index_custom_field_responses_on_writer_id_and_writer_type", using: :btree

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

  add_index "custom_fields", ["host_id", "host_type"], name: "index_custom_fields_on_host_id_and_host_type", using: :btree

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

  add_index "discounts", ["host_id", "host_type"], name: "index_discounts_on_host_id_and_host_type", using: :btree

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
    t.datetime "online_competition_sales_end_at"
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
    t.integer  "registration_id"
    t.integer  "host_id"
    t.string   "host_type",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "housing_provisions", ["host_id", "host_type"], name: "index_housing_provisions_on_host_id_and_host_type", using: :btree

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
    t.integer  "registration_id"
    t.integer  "host_id"
    t.string   "host_type",                      limit: 255
    t.integer  "housing_provision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.datetime "deleted_at"
  end

  add_index "housing_requests", ["host_id", "host_type"], name: "index_housing_requests_on_host_id_and_host_type", using: :btree

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
    t.text     "description"
  end

  add_index "levels", ["event_id"], name: "index_levels_on_event_id", using: :btree

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
    t.integer  "initial_stock",                      default: 0, null: false
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

  add_index "membership_renewals", ["membership_option_id"], name: "index_membership_renewals_on_membership_option_id", using: :btree
  add_index "membership_renewals", ["user_id", "membership_option_id"], name: "index_membership_renewals_on_user_id_and_membership_option_id", using: :btree
  add_index "membership_renewals", ["user_id"], name: "index_membership_renewals_on_user_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "note"
    t.integer  "host_id"
    t.string   "host_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "author_id"
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
    t.datetime "picked_up_at"
  end

  add_index "order_line_items", ["line_item_id", "line_item_type"], name: "index_order_line_items_on_line_item_id_and_line_item_type", using: :btree
  add_index "order_line_items", ["order_id"], name: "index_order_line_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "payment_token",               limit: 255
    t.string   "payer_id",                    limit: 255
    t.text     "metadata"
    t.integer  "registration_id"
    t.integer  "host_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",                                    default: false,  null: false
    t.string   "payment_method",              limit: 255, default: "Cash", null: false
    t.decimal  "paid_amount"
    t.decimal  "net_amount_received",                     default: 0.0,    null: false
    t.decimal  "total_fee_amount",                        default: 0.0,    null: false
    t.integer  "user_id"
    t.string   "host_type",                   limit: 255
    t.datetime "payment_received_at"
    t.integer  "pricing_tier_id"
    t.decimal  "current_paid_amount",                     default: 0.0,    null: false
    t.decimal  "current_net_amount_received",             default: 0.0,    null: false
    t.decimal  "current_total_fee_amount",                default: 0.0,    null: false
    t.integer  "created_by_id"
    t.boolean  "is_fee_absorbed",                         default: true
    t.integer  "sub_total_in_cents",                      default: 0,      null: false
  end

  add_index "orders", ["created_by_id"], name: "index_orders_on_created_by_id", using: :btree
  add_index "orders", ["host_id", "host_type"], name: "index_orders_on_host_id_and_host_type", using: :btree
  add_index "orders", ["pricing_tier_id"], name: "index_orders_on_pricing_tier_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

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
    t.text     "description"
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
    t.integer  "registration_id"
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

  add_index "pricing_tiers", ["event_id"], name: "index_pricing_tiers_on_event_id", using: :btree

  create_table "raffles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "event_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
  end

  create_table "registrations", force: :cascade do |t|
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
    t.string   "transferred_to_name"
    t.integer  "transferred_to_user_id"
    t.datetime "transferred_at"
    t.string   "transfer_reason"
    t.string   "attendee_first_name"
    t.string   "attendee_last_name"
    t.string   "phone_number"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  add_index "registrations", ["attendee_id"], name: "index_registrations_on_attendee_id", using: :btree
  add_index "registrations", ["host_id", "host_type"], name: "index_registrations_on_host_id_and_host_type", using: :btree

  create_table "restraints", force: :cascade do |t|
    t.integer "dependable_id"
    t.string  "dependable_type",   limit: 255
    t.integer "restrictable_id"
    t.string  "restrictable_type", limit: 255
  end

  add_index "restraints", ["dependable_id", "dependable_type"], name: "index_restraints_on_dependable_id_and_dependable_type", using: :btree
  add_index "restraints", ["restrictable_id", "restrictable_type"], name: "index_restraints_on_restrictable_id_and_restrictable_type", using: :btree

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

  create_table "sponsorships", force: :cascade do |t|
    t.integer  "sponsor_id"
    t.string   "sponsor_type"
    t.integer  "sponsored_id"
    t.string   "sponsored_type"
    t.integer  "discount_id"
    t.string   "discount_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "sponsorships", ["discount_id", "discount_type"], name: "index_sponsorships_on_discount_id_and_discount_type", using: :btree
  add_index "sponsorships", ["sponsor_type", "sponsor_id"], name: "index_sponsorships_on_sponsor_type_and_sponsor_id", using: :btree
  add_index "sponsorships", ["sponsored_type", "sponsored_id"], name: "index_sponsorships_on_sponsored_type_and_sponsored_id", using: :btree

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
