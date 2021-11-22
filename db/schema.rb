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

ActiveRecord::Schema.define(version: 2021_11_19_065915) do

  create_table "commutes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "car_type"
    t.string "car_route"
    t.integer "car_distance"
    t.string "train_route"
    t.integer "train_fee"
    t.string "pass_route"
    t.integer "pass_fee"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_commutes_on_user_id"
  end

  create_table "days", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "year_month_id", null: false
    t.date "date", null: false
    t.string "day_type", limit: 255, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["year_month_id"], name: "index_days_on_year_month_id"
  end

  create_table "pending_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.string "schedule_type", limit: 255
    t.string "status", limit: 255, null: false
    t.text "comment_request"
    t.text "comment_permission"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["schedule_id"], name: "index_pending_schedules_on_schedule_id"
  end

  create_table "pending_timecards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "timecard_id", null: false
    t.string "timecard_type", limit: 255, null: false
    t.time "pending_time"
    t.string "status", limit: 255, null: false
    t.text "comment_request"
    t.text "comment_permission"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["timecard_id"], name: "index_pending_timecards_on_timecard_id"
  end

  create_table "schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "day_id", null: false
    t.string "schedule_type", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_schedules_on_day_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "timecards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "day_id", null: false
    t.time "start"
    t.time "finish"
    t.time "break_start"
    t.time "break_finish"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_timecards_on_day_id"
    t.index ["user_id"], name: "index_timecards_on_user_id"
  end

  create_table "travel_costs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "day_id", null: false
    t.string "commute_type", null: false
    t.integer "travel_cost", null: false
    t.string "remark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_travel_costs_on_day_id"
    t.index ["user_id"], name: "index_travel_costs_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "last_name", limit: 255, null: false
    t.string "first_name", limit: 255, null: false
    t.string "department", limit: 255, null: false
    t.string "user_type", limit: 255, null: false
    t.date "hire_date", null: false
    t.integer "approver_id"
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "year_months", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.date "first_date", null: false
    t.date "last_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "commutes", "users"
  add_foreign_key "days", "year_months"
  add_foreign_key "pending_schedules", "schedules"
  add_foreign_key "pending_timecards", "timecards"
  add_foreign_key "schedules", "days"
  add_foreign_key "schedules", "users"
  add_foreign_key "timecards", "days"
  add_foreign_key "timecards", "users"
  add_foreign_key "travel_costs", "days"
  add_foreign_key "travel_costs", "users"
end
