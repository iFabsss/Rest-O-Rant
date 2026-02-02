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

ActiveRecord::Schema[8.1].define(version: 2026_02_02_075445) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "reservations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "contact_email", null: false
    t.string "contact_name", null: false
    t.string "contact_number", null: false
    t.datetime "created_at", null: false
    t.integer "people_num", null: false
    t.bigint "timeslot_x_table_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["timeslot_x_table_id"], name: "index_reservations_on_timeslot_x_table_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.string "key_hash"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash"
  end

  create_table "tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "max_people", null: false
    t.integer "table_no", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timeslot_x_tables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "status", default: "available", null: false
    t.bigint "table_id", null: false
    t.uuid "timeslot_id", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_timeslot_x_tables_on_table_id"
    t.index ["timeslot_id", "table_id"], name: "index_timeslot_x_tables_on_timeslot_id_and_table_id", unique: true
    t.index ["timeslot_id"], name: "index_timeslot_x_tables_on_timeslot_id"
  end

  create_table "timeslots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.time "end_time", null: false
    t.integer "max_no_tables", null: false
    t.time "start_time", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "reservations", "timeslot_x_tables"
  add_foreign_key "reservations", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "timeslot_x_tables", "tables"
  add_foreign_key "timeslot_x_tables", "timeslots"
end
