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

ActiveRecord::Schema.define(version: 2018_11_19_121059) do

  create_table "checklists", force: :cascade do |t|
    t.integer "number"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sirabasu_id"
    t.integer "cid"
    t.integer "userid"
  end

  create_table "checkusers", force: :cascade do |t|
    t.integer "kanrisya_id"
    t.integer "checklist_id"
    t.boolean "check_ok", default: false, null: false
    t.boolean "boolean", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crews", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "age"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "crew_number"
    t.string "image"
    t.string "password_digest"
  end

  create_table "images", force: :cascade do |t|
    t.string "image_path"
    t.integer "sirabasu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kanrisyas", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "age"
    t.string "sex"
    t.string "crew_number"
    t.boolean "admin", default: false, null: false
    t.integer "cid"
    t.text "check"
    t.string "image"
    t.datetime "check_time"
    t.index ["email"], name: "index_kanrisyas_on_email", unique: true
    t.index ["reset_password_token"], name: "index_kanrisyas_on_reset_password_token", unique: true
  end

  create_table "publishing_configs", force: :cascade do |t|
    t.integer "sirabasu_id"
    t.integer "required_sirabasu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessionsses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sirabasus", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "userid"
    t.integer "cid"
    t.json "image"
  end

  create_table "sirabasuusers", force: :cascade do |t|
    t.integer "kanrisya_id"
    t.integer "sirabasu_id"
    t.boolean "sirabasu_ok", default: false, null: false
    t.boolean "boolean", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
