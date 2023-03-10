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

ActiveRecord::Schema.define(version: 20211209202621) do

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string   "district_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "time"
    t.integer  "student_id"
    t.integer  "med_id"
    t.boolean  "complete"
    t.string   "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "district"
    t.integer  "amount"
  end

  create_table "forms", force: :cascade do |t|
    t.boolean  "nurse_approved"
    t.boolean  "parent_approved"
    t.string   "complete_boolean"
    t.text     "body",             limit: 100000
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "studentID"
    t.integer  "districtID"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "med_id"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "studentID"
    t.integer  "districtID"
    t.string   "notes"
    t.string   "medName"
  end

  create_table "medications", force: :cascade do |t|
    t.string   "brand_name"
    t.string   "active_ing"
    t.string   "method"
    t.string   "strength"
    t.string   "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nurses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parents", force: :cascade do |t|
    t.integer  "students_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "parents_students", id: false, force: :cascade do |t|
    t.integer "parent_id",  null: false
    t.integer "student_id", null: false
  end

  add_index "parents_students", ["parent_id", "student_id"], name: "index_parents_students_on_parent_id_and_student_id"
  add_index "parents_students", ["student_id", "parent_id"], name: "index_parents_students_on_student_id_and_parent_id"

  create_table "requests", force: :cascade do |t|
    t.datetime "time1"
    t.datetime "time2"
    t.datetime "time3"
    t.datetime "time4"
    t.string   "daily_doses"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "student_id"
    t.integer  "requestor_id"
    t.integer  "med_id"
    t.integer  "district_id"
    t.string   "notes"
    t.boolean  "parent_approved"
    t.boolean  "nurse_approved"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "med_name"
    t.integer  "amount"
    t.string   "units"
  end

  create_table "students", force: :cascade do |t|
    t.integer  "medications_id"
    t.integer  "events_id"
    t.string   "year"
    t.integer  "parents_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "role"
    t.integer  "role_id"
    t.integer  "district_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "password_set_token"
    t.datetime "password_set_sent_at"
    t.string   "session_token"
    t.string   "phone"
    t.boolean  "text_notification",    default: false
    t.boolean  "email_notification",   default: false
  end

  add_index "users", ["session_token"], name: "index_users_on_session_token"

end
