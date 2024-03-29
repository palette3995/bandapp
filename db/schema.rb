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

ActiveRecord::Schema[7.0].define(version: 2023_03_14_130022) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "band_genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id"
    t.integer "genre_id"
    t.integer "priority"
    t.string "other_genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_band_genres_on_band_id"
  end

  create_table "band_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "band_id"
    t.integer "part_id"
    t.string "other_part"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_band_members_on_band_id"
    t.index ["user_id"], name: "index_band_members_on_user_id"
  end

  create_table "bands", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "introduction"
    t.integer "prefecture_id"
    t.string "original"
    t.string "motivation"
    t.string "image"
    t.string "want_to_copy"
    t.string "activity_time"
    t.string "available_day"
    t.string "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "maximum_age"
    t.integer "minimum_age"
    t.integer "average_age"
    t.integer "number_of_member"
    t.integer "men"
    t.integer "women"
  end

  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "band_id", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_chats_on_band_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "favorited_user_id"
    t.bigint "band_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_favorites_on_band_id"
    t.index ["favorited_user_id"], name: "index_favorites_on_favorited_user_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "subject_type"
    t.bigint "subject_id"
    t.integer "notification_type", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_type", "subject_id"], name: "index_notifications_on_subject"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "recruit_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id"
    t.integer "part_id"
    t.string "level"
    t.string "other_part"
    t.string "age"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_recruit_members_on_band_id"
  end

  create_table "scouts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "scouted_user_id"
    t.bigint "band_id"
    t.bigint "scouted_band_id"
    t.integer "part_id"
    t.integer "scouted_part_id"
    t.string "other_part"
    t.string "scouted_other_part"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_scouts_on_band_id"
    t.index ["scouted_band_id"], name: "index_scouts_on_scouted_band_id"
    t.index ["scouted_user_id"], name: "index_scouts_on_scouted_user_id"
    t.index ["user_id"], name: "index_scouts_on_user_id"
  end

  create_table "user_genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "genre_id"
    t.integer "priority"
    t.string "other_genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_genres_on_user_id"
  end

  create_table "user_parts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "part_id"
    t.integer "priority"
    t.string "other_part"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_parts_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "age"
    t.string "sex"
    t.string "favorite"
    t.text "introduction"
    t.string "image"
    t.string "movie"
    t.string "sound"
    t.string "original"
    t.string "want_to_copy"
    t.string "motivation"
    t.integer "prefecture_id"
    t.string "frequency"
    t.string "activity_time"
    t.string "available_day"
    t.boolean "compose", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "band_genres", "bands"
  add_foreign_key "band_members", "bands"
  add_foreign_key "band_members", "users"
  add_foreign_key "chats", "bands"
  add_foreign_key "chats", "users"
  add_foreign_key "favorites", "bands"
  add_foreign_key "favorites", "users"
  add_foreign_key "favorites", "users", column: "favorited_user_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "recruit_members", "bands"
  add_foreign_key "scouts", "bands"
  add_foreign_key "scouts", "bands", column: "scouted_band_id"
  add_foreign_key "scouts", "users"
  add_foreign_key "scouts", "users", column: "scouted_user_id"
  add_foreign_key "user_genres", "users"
end
