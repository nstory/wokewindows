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

ActiveRecord::Schema.define(version: 2020_09_20_172426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "url", null: false
    t.string "title"
    t.text "admin_note"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "date_published"
    t.index ["url"], name: "index_articles_on_url", unique: true
  end

  create_table "articles_officers", force: :cascade do |t|
    t.integer "officer_id"
    t.integer "article_id"
    t.string "status", default: "added", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id", "officer_id"], name: "index_articles_officers_on_article_id_and_officer_id", unique: true
    t.index ["officer_id", "status", "article_id"], name: "index_articles_officers_on_officer_id_and_status_and_article_id"
  end

  create_table "cases", force: :cascade do |t|
    t.string "case_number"
    t.string "court"
    t.string "date"
    t.decimal "amount"
    t.string "motor_vehicle"
    t.text "attributions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "bag_of_text"
    t.index ["amount"], name: "index_cases_on_amount"
    t.index ["bag_of_text"], name: "cases_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["case_number"], name: "index_cases_on_case_number"
    t.index ["court", "case_number"], name: "index_cases_on_court_and_case_number", unique: true
    t.index ["date"], name: "index_cases_on_date"
  end

  create_table "cases_incidents", force: :cascade do |t|
    t.integer "case_id", null: false
    t.integer "incident_id"
    t.string "incident_number"
    t.index ["case_id"], name: "index_cases_incidents_on_case_id"
  end

  create_table "citations", force: :cascade do |t|
    t.integer "officer_id"
    t.string "issuing_agency"
    t.string "ticket_number"
    t.integer "officer_number"
    t.string "ticket_type"
    t.string "source"
    t.string "violator_type"
    t.boolean "cdl"
    t.string "license_class"
    t.string "event_date"
    t.integer "location_id"
    t.string "location_name"
    t.integer "posted_speed"
    t.integer "violation_speed"
    t.boolean "posted"
    t.string "radar"
    t.string "clocked"
    t.string "race"
    t.string "sex"
    t.string "vehicle_color"
    t.string "make"
    t.integer "model_year"
    t.boolean "sixteen_pass"
    t.boolean "haz_mat"
    t.decimal "amount"
    t.boolean "paid"
    t.boolean "hearing_requested"
    t.string "court_code"
    t.integer "age"
    t.boolean "searched"
    t.text "offenses"
    t.text "attributions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "bag_of_text"
    t.index ["bag_of_text"], name: "citations_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["event_date"], name: "index_citations_on_event_date"
    t.index ["officer_id"], name: "index_citations_on_officer_id"
    t.index ["ticket_number"], name: "index_citations_on_ticket_number", unique: true
  end

  create_table "citations_field_contacts", id: false, force: :cascade do |t|
    t.bigint "field_contact_id", null: false
    t.bigint "citation_id", null: false
    t.index ["citation_id", "field_contact_id"], name: "index_cfc_on_citation_id_and_field_contact_id", unique: true
    t.index ["field_contact_id", "citation_id"], name: "index_cfc_on_field_contact_id_and_citation_id"
  end

  create_table "compensations", force: :cascade do |t|
    t.bigint "officer_id"
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
    t.text "attributions"
    t.index ["officer_id"], name: "index_compensations_on_officer_id"
  end

  create_table "complaint_officers", force: :cascade do |t|
    t.bigint "complaint_id"
    t.bigint "officer_id"
    t.string "name"
    t.string "title"
    t.string "badge"
    t.string "allegation"
    t.string "finding"
    t.string "finding_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["complaint_id"], name: "index_complaint_officers_on_complaint_id"
    t.index ["officer_id"], name: "index_complaint_officers_on_officer_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.string "ia_number"
    t.integer "case_number"
    t.string "incident_type"
    t.string "received_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "occurred_date"
    t.string "summary"
    t.text "attributions"
    t.text "bag_of_text"
    t.index ["bag_of_text"], name: "complaints_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["ia_number"], name: "index_complaints_on_ia_number", unique: true
  end

  create_table "contributions", force: :cascade do |t|
    t.string "type"
    t.string "date"
    t.string "contributor"
    t.integer "zip"
    t.string "employer"
    t.string "occupation"
    t.decimal "amount"
    t.string "committee_name"
    t.integer "officer_id"
    t.integer "cpf_id"
    t.string "candidate_full_name"
    t.string "office_type"
    t.string "district"
    t.string "party_affiliation"
    t.string "committee_id"
    t.string "memo_text"
    t.string "receipt_type_full"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "details", force: :cascade do |t|
    t.integer "officer_id"
    t.integer "tracking_no"
    t.integer "employee_number"
    t.string "employee_name"
    t.integer "employee_rank"
    t.integer "customer_number"
    t.string "customer_name"
    t.string "street_no"
    t.string "street"
    t.string "xstreet"
    t.string "start_date_time"
    t.string "end_date_time"
    t.integer "minutes_worked"
    t.string "detail_type"
    t.integer "pay_hours"
    t.integer "pay_amount"
    t.integer "pay_rate"
    t.text "attributions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "bag_of_text"
    t.float "latitude"
    t.float "longitude"
    t.index ["bag_of_text"], name: "details_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["officer_id"], name: "index_details_on_officer_id"
    t.index ["start_date_time"], name: "index_details_on_start_date_time"
    t.index ["tracking_no"], name: "index_details_on_tracking_no", unique: true
  end

  create_table "field_contact_names", force: :cascade do |t|
    t.bigint "field_contact_id"
    t.string "fc_num"
    t.string "contact_date"
    t.string "sex"
    t.string "race"
    t.integer "age"
    t.string "build"
    t.string "hair_style"
    t.string "skin_tone"
    t.string "ethnicity"
    t.string "other_clothing"
    t.boolean "deceased"
    t.string "license_state"
    t.string "license_type"
    t.boolean "frisked_searched"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "attributions"
    t.string "gender"
    t.index ["field_contact_id"], name: "index_field_contact_names_on_field_contact_id"
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
    t.bigint "contact_officer_id"
    t.bigint "supervisor_id"
    t.integer "field_contact_names_count", default: 0, null: false
    t.text "attributions"
    t.text "bag_of_text"
    t.string "stop_duration"
    t.boolean "search_vehicle"
    t.boolean "summons_issued"
    t.index ["bag_of_text"], name: "field_contacts_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["contact_date"], name: "index_field_contacts_on_contact_date"
    t.index ["contact_officer_id"], name: "index_field_contacts_on_contact_officer_id"
    t.index ["fc_num"], name: "index_field_contacts_on_fc_num", unique: true
    t.index ["supervisor_id"], name: "index_field_contacts_on_supervisor_id"
  end

  create_table "field_contacts_incidents", id: false, force: :cascade do |t|
    t.bigint "field_contact_id", null: false
    t.bigint "incident_id", null: false
    t.index ["field_contact_id", "incident_id"], name: "index_fc_incidents_on_field_contact_id_and_incident_id"
    t.index ["incident_id", "field_contact_id"], name: "index_fc_incidents_on_incident_id_and_field_contact_id", unique: true
  end

  create_table "geocodes", force: :cascade do |t|
    t.string "provider", null: false
    t.string "query", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["query", "provider"], name: "index_geocodes_on_query_and_provider", unique: true
  end

  create_table "imports", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_imports_on_name", unique: true
  end

  create_table "incidents", force: :cascade do |t|
    t.string "district"
    t.integer "reporting_area"
    t.boolean "shooting"
    t.string "occurred_on_date"
    t.string "ucr_part"
    t.string "street"
    t.float "latitude"
    t.float "longitude"
    t.string "report_date"
    t.text "location_of_occurrence"
    t.text "nature_of_incident"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "arrests_json"
    t.integer "incident_number"
    t.text "attributions"
    t.bigint "officer_id"
    t.string "officer_journal_name"
    t.jsonb "offenses", default: []
    t.text "bag_of_text"
    t.float "geocode_latitude"
    t.float "geocode_longitude"
    t.float "reported_latitude"
    t.float "reported_longitude"
    t.jsonb "nibrs_offenses", default: []
    t.string "location_type"
    t.string "incident_clearance"
    t.string "exceptional_clearance_date"
    t.integer "number_of_victims"
    t.integer "number_of_offenders"
    t.integer "number_of_arrestees"
    t.index ["bag_of_text"], name: "incidents_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["incident_number"], name: "index_incidents_on_incident_number", unique: true
    t.index ["occurred_on_date"], name: "index_incidents_on_occurred_on_date"
    t.index ["officer_id"], name: "index_incidents_on_officer_id"
  end

  create_table "officers", force: :cascade do |t|
    t.integer "employee_id"
    t.string "journal_name"
    t.string "hr_name"
    t.string "doa"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "badge"
    t.integer "field_contacts_count", default: 0, null: false
    t.integer "incidents_count", default: 0, null: false
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
    t.integer "complaints_count", default: 0, null: false
    t.text "attributions"
    t.text "bag_of_text"
    t.integer "swats_count", default: 0, null: false
    t.integer "details_count", default: 0, null: false
    t.integer "citations_count", default: 0, null: false
    t.integer "articles_officers_count", default: 0, null: false
    t.integer "ia_score"
    t.integer "earnings_rank"
    t.string "rank"
    t.string "organization"
    t.boolean "active", default: false, null: false
    t.index ["bag_of_text"], name: "officers_bag_of_text_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["employee_id"], name: "index_officers_on_employee_id", unique: true
    t.index ["total"], name: "index_officers_on_total"
  end

  create_table "overtimes", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "officer_id"
    t.string "name"
    t.string "rank"
    t.string "assigned"
    t.string "charged"
    t.string "date"
    t.integer "code"
    t.string "description"
    t.string "start_time"
    t.string "end_time"
    t.decimal "worked_hours"
    t.decimal "ot_hours"
    t.text "attributions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["officer_id"], name: "index_overtimes_on_officer_id"
  end

  create_table "swats", force: :cascade do |t|
    t.string "swat_number"
    t.string "date"
    t.text "attributions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["swat_number"], name: "index_swats_on_swat_number", unique: true
  end

  create_table "swats_incidents", force: :cascade do |t|
    t.integer "swat_id"
    t.integer "incident_id"
    t.string "incident_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["incident_id", "swat_id"], name: "index_swats_incidents_on_incident_id_and_swat_id"
    t.index ["swat_id", "incident_id"], name: "index_swats_incidents_on_swat_id_and_incident_id"
  end

  create_table "swats_officers", force: :cascade do |t|
    t.integer "swat_id"
    t.integer "officer_id"
    t.string "officer_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["officer_id", "swat_id"], name: "index_swats_officers_on_officer_id_and_swat_id"
    t.index ["swat_id", "officer_id"], name: "index_swats_officers_on_swat_id_and_officer_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "zip_codes", force: :cascade do |t|
    t.integer "zip"
    t.string "city"
    t.string "state"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["zip"], name: "index_zip_codes_on_zip", unique: true
  end

end
