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

ActiveRecord::Schema.define(version: 2020_06_13_154945) do

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

  create_table "field_contacts", force: :cascade do |t|
    t.string "fc_num"
    t.string "contact_date"
    t.integer "contact_officer_employee_id"
    t.string "contact_officer_name"
    t.integer "supervisor_employee_id"
    t.string "supervisor_name"
    t.string "street"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.boolean "frisked_searched"
    t.integer "stop_duration"
    t.string "circumstance"
    t.string "basis"
    t.integer "vehicle_year"
    t.string "vehicle_state"
    t.string "vehicle_make"
    t.string "vehicle_model"
    t.string "vehicle_color"
    t.string "vehicle_style"
    t.string "vehicle_type"
    t.text "key_situations"
    t.text "narrative"
    t.string "weather"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fc_num"], name: "index_field_contacts_on_fc_num", unique: true
  end

  create_table "incident_officers", force: :cascade do |t|
    t.integer "incident_id"
    t.integer "officer_id"
    t.string "journal_officer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["incident_id"], name: "index_incident_officers_on_incident_id"
    t.index ["officer_id"], name: "index_incident_officers_on_officer_id"
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
    t.text "arrests_json"
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