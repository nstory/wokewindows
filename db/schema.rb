# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_12_000320) do

  create_table "compensations", force: :cascade do |t|
    t.integer "officer_id"
    t.string "name"
    t.string "department_name"
    t.string "title"
    t.decimal "regular"
    t.decimal "retro"
    t.decimal "other"
    t.decimal "overtime"
    t.decimal "injured"
    t.decimal "detail"
    t.decimal "quinn"
    t.decimal "total"
    t.integer "postal"
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["officer_id"], name: "index_compensations_on_officer_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.string "incident_number"
    t.string "district"
    t.integer "reporting_area"
    t.boolean "shooting"
    t.string "occurred_on_date"
    t.string "ucr_part"
    t.string "street"
    t.float "latitude"
    t.float "longitude"
    t.datetime "report_date"
    t.text "location_of_occurrence"
    t.text "nature_of_incident"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "offenses", force: :cascade do |t|
    t.integer "incident_id"
    t.integer "code"
    t.string "code_group"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["incident_id"], name: "index_offenses_on_incident_id"
  end

  create_table "officers", force: :cascade do |t|
    t.integer "employee_id"
    t.string "journal_name"
    t.string "hr_name"
    t.string "doa"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_officers_on_employee_id", unique: true
  end

end
