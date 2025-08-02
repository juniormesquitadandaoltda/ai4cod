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

ActiveRecord::Schema[7.0].define(version: 2025_06_07_200710) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.bigint "subscription_id"
    t.string "searchable_record_type", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["name", "record_type", "record_id", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["record_type", "record_id"], name: "index_active_storage_attachments_on_record"
    t.index ["subscription_id"], name: "index_active_storage_attachments_on_subscription_id"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.jsonb "metadata", default: {}, null: false
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "searchable_filename", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.jsonb "object", default: {}, null: false
    t.jsonb "object_changes", default: {}, null: false
    t.bigint "whodunnit_id", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_audits_on_item_type_and_item_id"
    t.index ["owner_id"], name: "index_audits_on_owner_id"
    t.index ["whodunnit_id"], name: "index_audits_on_whodunnit_id"
  end

  create_table "calleds", force: :cascade do |t|
    t.string "subject", null: false
    t.string "searchable_subject", default: "", null: false
    t.text "message", null: false
    t.text "searchable_message", default: "", null: false
    t.text "answer"
    t.text "searchable_answer", default: "", null: false
    t.bigint "subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((subject)::text), subscription_id", name: "index_calleds_on_LOWER_subject_subscription_id", unique: true
    t.index ["subscription_id"], name: "index_calleds_on_subscription_id"
  end

  create_table "collaborators", force: :cascade do |t|
    t.boolean "actived", default: false, null: false
    t.bigint "user_id", null: false
    t.bigint "subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_collaborators_on_subscription_id"
    t.index ["user_id", "subscription_id"], name: "index_collaborators_on_user_id_and_subscription_id", unique: true
    t.index ["user_id"], name: "index_collaborators_on_user_id"
  end

  create_table "facilitators", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "notes"
    t.bigint "subscription_id", null: false
    t.string "searchable_name", default: "", null: false
    t.string "searchable_email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text), subscription_id", name: "index_facilitators_on_LOWER_email_subscription_id", unique: true
    t.index ["subscription_id"], name: "index_facilitators_on_subscription_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "resource", null: false
    t.string "name", null: false
    t.jsonb "values", default: [], null: false
    t.bigint "subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource", "subscription_id"], name: "index_fields_on_name_and_resource_and_subscription_id", unique: true
    t.index ["subscription_id"], name: "index_fields_on_subscription_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "url", null: false
    t.jsonb "headers", default: {}, null: false
    t.jsonb "body", default: {}, null: false
    t.bigint "notificator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notificator_id"], name: "index_notifications_on_notificator_id"
  end

  create_table "notificators", force: :cascade do |t|
    t.string "name", null: false
    t.string "searchable_name", default: "", null: false
    t.boolean "actived", default: false, null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "notifications_count", default: 0, null: false
    t.index "lower((name)::text)", name: "index_notificators_on_LOWER_name", unique: true
    t.index "lower((token)::text)", name: "index_notificators_on_LOWER_token", unique: true
  end

  create_table "proprietors", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "notes"
    t.bigint "subscription_id", null: false
    t.string "searchable_name", default: "", null: false
    t.string "searchable_email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text), subscription_id", name: "index_proprietors_on_LOWER_email_subscription_id", unique: true
    t.index ["subscription_id"], name: "index_proprietors_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "actived", default: false, null: false
    t.bigint "user_id", null: false
    t.string "searchable_name", default: "", null: false
    t.date "due_date", null: false
    t.bigint "current_records_count", default: 0, null: false
    t.bigint "maximum_records_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "collaborators_count", default: 0, null: false
    t.bigint "webhooks_count", default: 0, null: false
    t.bigint "calleds_count", default: 0, null: false
    t.bigint "fields_count", default: 0, null: false
    t.bigint "proprietors_count", default: 0, null: false
    t.bigint "facilitators_count", default: 0, null: false
    t.bigint "vehicles_count", default: 0, null: false
    t.bigint "tasks_count", default: 0, null: false
    t.bigint "archives_count", default: 0, null: false
    t.index "lower((name)::text), user_id", name: "index_subscriptions_on_LOWER_name_user_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name", null: false
    t.string "stage", null: false
    t.string "next_stage"
    t.string "searchable_name", default: "", null: false
    t.datetime "scheduling_at"
    t.bigint "vehicle_id", null: false
    t.bigint "subscription_id", null: false
    t.boolean "shared", default: false, null: false
    t.bigint "facilitator_id"
    t.bigint "proprietor_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facilitator_id"], name: "index_tasks_on_facilitator_id"
    t.index ["next_stage"], name: "index_tasks_on_next_stage"
    t.index ["proprietor_id"], name: "index_tasks_on_proprietor_id"
    t.index ["stage"], name: "index_tasks_on_stage"
    t.index ["subscription_id"], name: "index_tasks_on_subscription_id"
    t.index ["vehicle_id"], name: "index_tasks_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.bigint "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.bigint "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.string "name", null: false
    t.string "profile", null: false
    t.string "status", null: false
    t.string "timezone", null: false
    t.string "locale", null: false
    t.string "searchable_email", default: "", null: false
    t.string "searchable_name", default: "", null: false
    t.datetime "destroyed_at", precision: nil
    t.datetime "access_sent_at", precision: nil
    t.boolean "policy_terms", default: false, null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "audits_count", default: 0, null: false
    t.bigint "subscriptions_count", default: 0, null: false
    t.bigint "collaborations_count", default: 0, null: false
    t.index "lower((email)::text)", name: "index_users_on_LOWER_email", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "chassis", null: false
    t.string "year", null: false
    t.string "brand", null: false
    t.string "model", null: false
    t.string "color", null: false
    t.string "fuel", null: false
    t.string "category", null: false
    t.string "kind", null: false
    t.string "plate"
    t.string "renavam"
    t.string "licensing"
    t.string "searchable_chassis", default: "", null: false
    t.string "searchable_year", default: "", null: false
    t.string "searchable_plate", default: "", null: false
    t.string "searchable_renavam", default: "", null: false
    t.string "searchable_licensing", default: "", null: false
    t.integer "seats", default: 0, null: false
    t.text "notes"
    t.bigint "subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((chassis)::text), subscription_id", name: "index_vehicles_on_LOWER_chassis_subscription_id", unique: true
    t.index ["brand"], name: "index_vehicles_on_brand"
    t.index ["category"], name: "index_vehicles_on_category"
    t.index ["color"], name: "index_vehicles_on_color"
    t.index ["fuel"], name: "index_vehicles_on_fuel"
    t.index ["kind"], name: "index_vehicles_on_kind"
    t.index ["model"], name: "index_vehicles_on_model"
    t.index ["subscription_id"], name: "index_vehicles_on_subscription_id"
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "url", null: false
    t.boolean "actived", default: false, null: false
    t.string "resource", null: false
    t.string "event", null: false
    t.jsonb "request_metadata", default: {}, null: false
    t.integer "requests_count", default: 0, null: false
    t.datetime "requested_at", precision: nil
    t.bigint "subscription_id", null: false
    t.string "searchable_url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((url)::text), event, subscription_id", name: "index_webhooks_on_LOWER_url_event_subscription_id", unique: true
    t.index ["subscription_id"], name: "index_webhooks_on_subscription_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_attachments", "subscriptions"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audits", "users", column: "owner_id"
  add_foreign_key "audits", "users", column: "whodunnit_id"
  add_foreign_key "calleds", "subscriptions"
  add_foreign_key "collaborators", "subscriptions"
  add_foreign_key "collaborators", "users"
  add_foreign_key "facilitators", "subscriptions"
  add_foreign_key "fields", "subscriptions"
  add_foreign_key "notifications", "notificators"
  add_foreign_key "proprietors", "subscriptions"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tasks", "facilitators"
  add_foreign_key "tasks", "proprietors"
  add_foreign_key "tasks", "subscriptions"
  add_foreign_key "tasks", "vehicles"
  add_foreign_key "vehicles", "subscriptions"
  add_foreign_key "webhooks", "subscriptions"
end
