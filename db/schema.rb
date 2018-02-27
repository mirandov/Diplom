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

ActiveRecord::Schema.define(version: 20171215170321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "city_id"
    t.integer  "street_id"
    t.integer  "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["city_id"], name: "index_addresses_on_city_id", using: :btree
  add_index "addresses", ["house_id"], name: "index_addresses_on_house_id", using: :btree
  add_index "addresses", ["site_id"], name: "index_addresses_on_site_id", using: :btree
  add_index "addresses", ["street_id"], name: "index_addresses_on_street_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "class_diseases", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "clinical_records", force: :cascade do |t|
    t.string   "record_number"
    t.string   "prefix"
    t.string   "suffix"
    t.date     "attachment_date"
    t.date     "last_registration_date"
    t.date     "detachment_date"
    t.text     "reason_for_detachment"
    t.integer  "site_id"
    t.integer  "patient_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "clinical_records", ["patient_id"], name: "index_clinical_records_on_patient_id", unique: true, using: :btree
  add_index "clinical_records", ["site_id"], name: "index_clinical_records_on_site_id", using: :btree

  create_table "complictations", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "information"
    t.integer  "class_disease_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "complictations", ["class_disease_id"], name: "index_complictations_on_class_disease_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "title"
    t.string   "short_title"
    t.text     "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "description_diagnoses", force: :cascade do |t|
    t.text     "comment"
    t.integer  "diagnosis_id"
    t.integer  "complictation_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "description_diagnoses", ["complictation_id"], name: "index_description_diagnoses_on_complictation_id", using: :btree
  add_index "description_diagnoses", ["diagnosis_id"], name: "index_description_diagnoses_on_diagnosis_id", using: :btree

  create_table "diagnoses", force: :cascade do |t|
    t.date     "resolution_date"
    t.integer  "patient_id"
    t.integer  "position_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "diagnoses", ["patient_id"], name: "index_diagnoses_on_patient_id", using: :btree
  add_index "diagnoses", ["position_id"], name: "index_diagnoses_on_position_id", using: :btree

  create_table "doctors", force: :cascade do |t|
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.string   "personnel_number"
    t.text     "information"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "houses", force: :cascade do |t|
    t.string   "house_number"
    t.integer  "street_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "houses", ["street_id"], name: "index_houses_on_street_id", using: :btree

  create_table "medical_policies", force: :cascade do |t|
    t.string   "mip_number"
    t.integer  "address_id"
    t.integer  "patient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "medical_policies", ["address_id"], name: "index_medical_policies_on_address_id", using: :btree
  add_index "medical_policies", ["patient_id"], name: "index_medical_policies_on_patient_id", unique: true, using: :btree

  create_table "passports", force: :cascade do |t|
    t.string   "serial_and_number"
    t.date     "issue_date"
    t.string   "issued_by"
    t.string   "passport_holder"
    t.integer  "patient_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "passports", ["patient_id"], name: "index_passports_on_patient_id", unique: true, using: :btree

  create_table "patients", force: :cascade do |t|
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.date     "birthday"
    t.string   "sex"
    t.string   "full_name_parent"
    t.string   "mobile_phone_number"
    t.string   "work_phone_number"
    t.string   "rank"
    t.string   "disability"
    t.string   "certificate_of_deceased_parent"
    t.string   "certificate_of_nuclear_power_plant"
    t.string   "inila"
    t.integer  "place_work_id"
    t.integer  "address_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "patients", ["address_id"], name: "index_patients_on_address_id", using: :btree
  add_index "patients", ["place_work_id"], name: "index_patients_on_place_work_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "ln"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "place_works", force: :cascade do |t|
    t.string   "job_name"
    t.string   "short_name"
    t.text     "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string   "position_name"
    t.string   "status"
    t.integer  "doctor_id"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "positions", ["department_id"], name: "index_positions_on_department_id", using: :btree
  add_index "positions", ["doctor_id"], name: "index_positions_on_doctor_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "site_name"
    t.string   "short_name"
    t.string   "region"
    t.text     "information"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "streets", force: :cascade do |t|
    t.string   "street_name"
    t.integer  "city_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "streets", ["city_id"], name: "index_streets_on_city_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "houses"
  add_foreign_key "addresses", "sites"
  add_foreign_key "addresses", "streets"
  add_foreign_key "clinical_records", "patients"
  add_foreign_key "clinical_records", "sites"
  add_foreign_key "complictations", "class_diseases"
  add_foreign_key "description_diagnoses", "complictations"
  add_foreign_key "description_diagnoses", "diagnoses"
  add_foreign_key "diagnoses", "patients"
  add_foreign_key "diagnoses", "positions"
  add_foreign_key "houses", "streets"
  add_foreign_key "medical_policies", "addresses"
  add_foreign_key "medical_policies", "patients"
  add_foreign_key "passports", "patients"
  add_foreign_key "patients", "addresses"
  add_foreign_key "patients", "place_works"
  add_foreign_key "positions", "departments"
  add_foreign_key "positions", "doctors"
  add_foreign_key "streets", "cities"
end
