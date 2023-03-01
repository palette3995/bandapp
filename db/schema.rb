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

ActiveRecord::Schema[7.0].define(version: 2023_03_01_034513) do
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
    t.bigint "genre_id"
    t.string "priority"
    t.string "other_genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_band_genres_on_band_id"
    t.index ["genre_id"], name: "index_band_genres_on_genre_id"
  end

  create_table "band_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "band_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "part_id"
    t.string "other_part"
    t.index ["band_id"], name: "index_band_members_on_band_id"
    t.index ["part_id"], name: "index_band_members_on_part_id"
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
    t.string "avairable_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "favorited_user_id"
    t.bigint "band_id"
    t.bigint "favorited_band_id"
    t.bigint "recruit_member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_favorites_on_band_id"
    t.index ["favorited_band_id"], name: "index_favorites_on_favorited_band_id"
    t.index ["favorited_user_id"], name: "index_favorites_on_favorited_user_id"
    t.index ["recruit_member_id"], name: "index_favorites_on_recruit_member_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recruit_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "band_id"
    t.bigint "part_id"
    t.string "level"
    t.string "other_part"
    t.integer "priority"
    t.string "age"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_recruit_members_on_band_id"
    t.index ["part_id"], name: "index_recruit_members_on_part_id"
  end

  create_table "scouts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "scouted_user_id"
    t.bigint "band_id"
    t.bigint "scouted_band_id"
    t.bigint "part_id"
    t.bigint "scouted_part_id"
    t.string "other_part"
    t.string "scouted_other_part"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.index ["band_id"], name: "index_scouts_on_band_id"
    t.index ["part_id"], name: "index_scouts_on_part_id"
    t.index ["scouted_band_id"], name: "index_scouts_on_scouted_band_id"
    t.index ["scouted_part_id"], name: "index_scouts_on_scouted_part_id"
    t.index ["scouted_user_id"], name: "index_scouts_on_scouted_user_id"
    t.index ["user_id"], name: "index_scouts_on_user_id"
  end

  create_table "user_genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "genre_id"
    t.integer "priority"
    t.string "other_genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_user_genres_on_genre_id"
    t.index ["user_id"], name: "index_user_genres_on_user_id"
  end

  create_table "user_parts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "part_id"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
    t.string "other_part"
    t.index ["part_id"], name: "index_user_parts_on_part_id"
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
    t.string "frequency"
    t.boolean "compose", default: false
    t.integer "prefecture_id"
    t.string "activity_time"
    t.string "available_day"
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
  add_foreign_key "band_genres", "genres"
  add_foreign_key "band_members", "bands"
  add_foreign_key "band_members", "parts"
  add_foreign_key "band_members", "users"
  add_foreign_key "favorites", "bands"
  add_foreign_key "favorites", "bands", column: "favorited_band_id"
  add_foreign_key "favorites", "recruit_members"
  add_foreign_key "favorites", "users"
  add_foreign_key "favorites", "users", column: "favorited_user_id"
  add_foreign_key "recruit_members", "bands"
  add_foreign_key "recruit_members", "parts"
  add_foreign_key "scouts", "bands"
  add_foreign_key "scouts", "bands", column: "scouted_band_id"
  add_foreign_key "scouts", "parts"
  add_foreign_key "scouts", "parts", column: "scouted_part_id"
  add_foreign_key "scouts", "users"
  add_foreign_key "scouts", "users", column: "scouted_user_id"
  add_foreign_key "user_genres", "genres"
  add_foreign_key "user_genres", "users"
end
