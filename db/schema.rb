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

ActiveRecord::Schema.define(version: 20141010232844) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "categories", force: true do |t|
    t.string  "name"
    t.integer "level_id"
    t.integer "type_id"
    t.integer "parent_id"
  end

  add_index "categories", ["level_id"], name: "index_categories_on_level_id", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["type_id"], name: "index_categories_on_type_id", using: :btree

  create_table "category_levels", force: true do |t|
    t.string  "name"
    t.integer "level"
    t.integer "type_id"
  end

  add_index "category_levels", ["type_id"], name: "index_category_levels_on_type_id", using: :btree

  create_table "category_types", force: true do |t|
    t.string "name"
  end

  create_table "customer_background_stats", force: true do |t|
    t.integer  "user_id"
    t.json     "result"
    t.string   "result_type"
    t.string   "result_name"
    t.json     "result_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_background_stats", ["user_id"], name: "index_customer_background_stats_on_user_id", using: :btree

  create_table "customer_calls", force: true do |t|
    t.integer "base_service_id"
    t.integer "base_subservice_id"
    t.integer "user_id"
    t.json    "own_phone"
    t.json    "partner_phone"
    t.json    "connect"
    t.json    "description"
  end

  add_index "customer_calls", ["base_service_id"], name: "index_customer_calls_on_base_service_id", using: :btree
  add_index "customer_calls", ["base_subservice_id"], name: "index_customer_calls_on_base_subservice_id", using: :btree
  add_index "customer_calls", ["user_id"], name: "index_customer_calls_on_user_id", using: :btree

  create_table "customer_categories", force: true do |t|
    t.string  "name"
    t.integer "level_id"
    t.integer "type_id"
    t.integer "parent_id"
  end

  add_index "customer_categories", ["level_id"], name: "index_customer_categories_on_level_id", using: :btree
  add_index "customer_categories", ["parent_id"], name: "index_customer_categories_on_parent_id", using: :btree
  add_index "customer_categories", ["type_id"], name: "index_customer_categories_on_type_id", using: :btree

  create_table "customer_infos", force: true do |t|
    t.integer  "user_id"
    t.integer  "info_type_id"
    t.json     "info"
    t.datetime "last_update"
  end

  add_index "customer_infos", ["info_type_id"], name: "index_customer_infos_on_info_type_id", using: :btree
  add_index "customer_infos", ["user_id"], name: "index_customer_infos_on_user_id", using: :btree

  create_table "customer_services", force: true do |t|
    t.integer  "user_id"
    t.string   "phone_number"
    t.integer  "tarif_class_id"
    t.integer  "tarif_list_id"
    t.integer  "status_id"
    t.datetime "valid_from"
    t.datetime "valid_till"
    t.json     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_services", ["status_id"], name: "index_customer_services_on_status_id", using: :btree
  add_index "customer_services", ["tarif_class_id"], name: "index_customer_services_on_tarif_class_id", using: :btree
  add_index "customer_services", ["tarif_list_id"], name: "index_customer_services_on_tarif_list_id", using: :btree
  add_index "customer_services", ["user_id"], name: "index_customer_services_on_user_id", using: :btree

  create_table "customer_stats", force: true do |t|
    t.integer  "user_id"
    t.string   "phone_number"
    t.text     "filtr"
    t.json     "result"
    t.datetime "stat_from"
    t.datetime "stat_till"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
    t.integer  "tarif_id"
    t.string   "accounting_period"
    t.string   "result_type"
    t.string   "result_name"
    t.json     "result_key"
  end

  add_index "customer_stats", ["user_id"], name: "index_customer_stats_on_user_id", using: :btree

  create_table "customer_transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "info_type_id"
    t.json     "status"
    t.json     "description"
    t.datetime "made_at"
  end

  add_index "customer_transactions", ["info_type_id"], name: "index_customer_transactions_on_info_type_id", using: :btree
  add_index "customer_transactions", ["user_id"], name: "index_customer_transactions_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "parameters", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "nick_name"
    t.integer "source_type_id"
    t.json    "source"
    t.json    "display"
    t.json    "unit"
  end

  add_index "parameters", ["source_type_id"], name: "index_parameters_on_source_type_id", using: :btree

  create_table "price_formulas", force: true do |t|
    t.string   "name"
    t.integer  "price_list_id"
    t.integer  "calculation_order"
    t.integer  "standard_formula_id"
    t.json     "formula"
    t.decimal  "price"
    t.integer  "price_unit_id"
    t.integer  "volume_id"
    t.integer  "volume_unit_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "price_formulas", ["name"], name: "index_price_formulas_on_name", using: :btree
  add_index "price_formulas", ["price_list_id"], name: "index_price_formulas_on_price_list_id", using: :btree
  add_index "price_formulas", ["standard_formula_id"], name: "index_price_formulas_on_standard_formula_id", using: :btree

  create_table "price_lists", force: true do |t|
    t.string   "name"
    t.integer  "tarif_class_id"
    t.integer  "tarif_list_id"
    t.integer  "service_category_group_id"
    t.integer  "service_category_tarif_class_id"
    t.boolean  "is_active"
    t.json     "features"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "price_lists", ["name"], name: "index_price_lists_on_name", using: :btree
  add_index "price_lists", ["service_category_group_id"], name: "index_price_lists_on_service_category_group_id", using: :btree
  add_index "price_lists", ["service_category_tarif_class_id"], name: "index_price_lists_on_service_category_tarif_class_id", using: :btree
  add_index "price_lists", ["tarif_class_id"], name: "index_price_lists_on_tarif_class_id", using: :btree
  add_index "price_lists", ["tarif_list_id"], name: "index_price_lists_on_tarif_list_id", using: :btree

  create_table "price_standard_formulas", force: true do |t|
    t.string  "name"
    t.json    "formula"
    t.integer "price_unit_id"
    t.integer "volume_id"
    t.integer "volume_unit_id"
    t.text    "description"
  end

  add_index "price_standard_formulas", ["name"], name: "index_price_standard_formulas_on_name", using: :btree

  create_table "relations", force: true do |t|
    t.integer "type_id"
    t.string  "name"
    t.integer "owner_id"
    t.integer "parent_id"
    t.integer "children",       default: [], array: true
    t.integer "children_level", default: 1
  end

  add_index "relations", ["type_id"], name: "index_relations_on_type_id", using: :btree

  create_table "service_categories", force: true do |t|
    t.string  "name"
    t.integer "type_id"
    t.integer "parent_id"
    t.integer "level"
    t.integer "path",      default: [], array: true
  end

  add_index "service_categories", ["parent_id"], name: "index_service_categories_on_parent_id", using: :btree
  add_index "service_categories", ["path"], name: "index_service_categories_on_path", using: :gin
  add_index "service_categories", ["type_id"], name: "index_service_categories_on_type_id", using: :btree

  create_table "service_category_groups", force: true do |t|
    t.string   "name"
    t.integer  "operator_id"
    t.integer  "tarif_class_id"
    t.json     "criteria"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "conditions"
  end

  add_index "service_category_groups", ["name"], name: "index_service_category_groups_on_name", using: :btree
  add_index "service_category_groups", ["operator_id"], name: "index_service_category_groups_on_operator_id", using: :btree
  add_index "service_category_groups", ["tarif_class_id"], name: "index_service_category_groups_on_tarif_class_id", using: :btree

  create_table "service_category_tarif_classes", force: true do |t|
    t.integer  "tarif_class_id"
    t.integer  "service_category_rouming_id"
    t.integer  "service_category_geo_id"
    t.integer  "service_category_partner_type_id"
    t.integer  "service_category_calls_id"
    t.integer  "service_category_one_time_id"
    t.integer  "service_category_periodic_id"
    t.integer  "as_standard_category_group_id"
    t.integer  "as_tarif_class_service_category_id"
    t.integer  "tarif_class_service_categories",     default: [], array: true
    t.integer  "standard_category_groups",           default: [], array: true
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
    t.json     "conditions"
    t.integer  "tarif_option_id"
    t.integer  "tarif_option_order"
  end

  add_index "service_category_tarif_classes", ["as_standard_category_group_id"], name: "service_category_tarif_classes_as_standard_category_group_id", using: :btree
  add_index "service_category_tarif_classes", ["as_tarif_class_service_category_id"], name: "service_category_tarif_classes_as_tarif_class_service_category", using: :btree
  add_index "service_category_tarif_classes", ["service_category_calls_id"], name: "service_category_tarif_classes_service_category_calls_id", using: :btree
  add_index "service_category_tarif_classes", ["service_category_geo_id"], name: "service_category_tarif_classes_service_category_geo_id", using: :btree
  add_index "service_category_tarif_classes", ["service_category_one_time_id"], name: "service_category_tarif_classes_service_category_one_time_id", using: :btree
  add_index "service_category_tarif_classes", ["service_category_partner_type_id"], name: "service_category_tarif_classes_service_category_partner_type_id", using: :btree
  add_index "service_category_tarif_classes", ["service_category_periodic_id"], name: "service_category_tarif_classes_service_category_periodic_id", using: :btree
  add_index "service_category_tarif_classes", ["service_category_rouming_id"], name: "service_category_tarif_classes_service_category_rouming_id", using: :btree
  add_index "service_category_tarif_classes", ["standard_category_groups"], name: "service_category_tarif_classes_standard_category_groups", using: :gin
  add_index "service_category_tarif_classes", ["tarif_class_id"], name: "service_category_tarif_classes_tarif_class_id", using: :btree
  add_index "service_category_tarif_classes", ["tarif_class_service_categories"], name: "service_category_tarif_classes_tarif_class_service_categories", using: :gin
  add_index "service_category_tarif_classes", ["tarif_option_id"], name: "index_service_category_tarif_classes_on_tarif_option_id", using: :btree

  create_table "service_criteria", force: true do |t|
    t.integer "service_category_id"
    t.integer "criteria_param_id"
    t.integer "comparison_operator_id"
    t.integer "value_param_id"
    t.integer "value_choose_option_id"
    t.json    "value"
    t.text    "eval_string"
  end

  add_index "service_criteria", ["comparison_operator_id"], name: "index_service_criteria_on_comparison_operator_id", using: :btree
  add_index "service_criteria", ["criteria_param_id"], name: "index_service_criteria_on_criteria_param_id", using: :btree
  add_index "service_criteria", ["service_category_id"], name: "index_service_criteria_on_service_category_id", using: :btree
  add_index "service_criteria", ["value_choose_option_id"], name: "index_service_criteria_on_value_choose_option_id", using: :btree
  add_index "service_criteria", ["value_param_id"], name: "index_service_criteria_on_value_param_id", using: :btree

  create_table "service_priorities", force: true do |t|
    t.integer "type_id"
    t.integer "main_tarif_class_id"
    t.integer "dependent_tarif_class_id"
    t.integer "relation_id"
    t.integer "value"
    t.integer "arr_value",                default: [], array: true
  end

  add_index "service_priorities", ["dependent_tarif_class_id"], name: "index_service_priorities_on_dependent_tarif_class_id", using: :btree
  add_index "service_priorities", ["main_tarif_class_id"], name: "index_service_priorities_on_main_tarif_class_id", using: :btree
  add_index "service_priorities", ["relation_id"], name: "index_service_priorities_on_relation_id", using: :btree
  add_index "service_priorities", ["type_id"], name: "index_service_priorities_on_type_id", using: :btree

  create_table "tarif_classes", force: true do |t|
    t.string   "name"
    t.integer  "operator_id"
    t.integer  "privacy_id"
    t.integer  "standard_service_id"
    t.json     "features"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "dependency"
  end

  add_index "tarif_classes", ["name"], name: "index_tarif_classes_on_name", using: :btree
  add_index "tarif_classes", ["operator_id"], name: "index_tarif_classes_on_operator_id", using: :btree
  add_index "tarif_classes", ["privacy_id"], name: "index_tarif_classes_on_privacy_id", using: :btree
  add_index "tarif_classes", ["standard_service_id"], name: "index_tarif_classes_on_standard_service_id", using: :btree

  create_table "tarif_lists", force: true do |t|
    t.string   "name"
    t.integer  "tarif_class_id"
    t.integer  "region_id"
    t.json     "features"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tarif_lists", ["name"], name: "index_tarif_lists_on_name", using: :btree
  add_index "tarif_lists", ["region_id"], name: "index_tarif_lists_on_region_id", using: :btree
  add_index "tarif_lists", ["tarif_class_id"], name: "index_tarif_lists_on_tarif_class_id", using: :btree

  create_table "tests", force: true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "description"
    t.integer  "location_id"
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
