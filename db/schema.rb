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

ActiveRecord::Schema.define(version: 20151105132236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name",       limit: 255
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.integer "type_id"
    t.integer "level_id"
    t.integer "parent_id"
  end

  add_index "categories", ["level_id"], name: "index_categories_on_level_id", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["type_id"], name: "index_categories_on_type_id", using: :btree

  create_table "category_levels", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "level"
    t.integer "type_id"
  end

  add_index "category_levels", ["type_id"], name: "index_category_levels_on_type_id", using: :btree

  create_table "category_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "content_articles", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "title",      limit: 255
    t.json     "content"
    t.integer  "type_id"
    t.integer  "status_id"
    t.json     "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_articles", ["author_id"], name: "index_content_articles_on_author_id", using: :btree
  add_index "content_articles", ["status_id"], name: "index_content_articles_on_status_id", using: :btree
  add_index "content_articles", ["type_id"], name: "index_content_articles_on_type_id", using: :btree

  create_table "content_categories", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.integer "level_id"
    t.integer "type_id"
    t.integer "parent_id"
  end

  add_index "content_categories", ["level_id"], name: "index_content_categories_on_level_id", using: :btree
  add_index "content_categories", ["parent_id"], name: "index_content_categories_on_parent_id", using: :btree
  add_index "content_categories", ["type_id"], name: "index_content_categories_on_type_id", using: :btree

  create_table "customer_background_stats", force: :cascade do |t|
    t.integer  "user_id"
    t.json     "result"
    t.string   "result_type", limit: 255
    t.string   "result_name", limit: 255
    t.json     "result_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_background_stats", ["user_id"], name: "index_customer_background_stats_on_user_id", using: :btree

  create_table "customer_calls", force: :cascade do |t|
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

  create_table "customer_categories", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.integer "level_id"
    t.integer "type_id"
    t.integer "parent_id"
  end

  add_index "customer_categories", ["level_id"], name: "index_customer_categories_on_level_id", using: :btree
  add_index "customer_categories", ["parent_id"], name: "index_customer_categories_on_parent_id", using: :btree
  add_index "customer_categories", ["type_id"], name: "index_customer_categories_on_type_id", using: :btree

  create_table "customer_demands", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "type_id"
    t.json     "info"
    t.integer  "status_id"
    t.integer  "responsible_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customer_demands", ["customer_id"], name: "index_customer_demands_on_customer_id", using: :btree
  add_index "customer_demands", ["responsible_id"], name: "index_customer_demands_on_responsible_id", using: :btree
  add_index "customer_demands", ["status_id"], name: "index_customer_demands_on_status_id", using: :btree
  add_index "customer_demands", ["type_id"], name: "index_customer_demands_on_type_id", using: :btree

  create_table "customer_infos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "info_type_id"
    t.json     "info"
    t.datetime "last_update"
  end

  add_index "customer_infos", ["info_type_id"], name: "index_customer_infos_on_info_type_id", using: :btree
  add_index "customer_infos", ["user_id"], name: "index_customer_infos_on_user_id", using: :btree

  create_table "customer_services", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone_number",   limit: 255
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

  create_table "customer_stats", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone_number",      limit: 255
    t.text     "filtr"
    t.json     "result"
    t.datetime "stat_from"
    t.datetime "stat_till"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operator_id"
    t.integer  "tarif_id"
    t.string   "accounting_period", limit: 255
    t.string   "result_type",       limit: 255
    t.string   "result_name",       limit: 255
    t.json     "result_key"
  end

  add_index "customer_stats", ["user_id"], name: "index_customer_stats_on_user_id", using: :btree

  create_table "customer_transactions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "info_type_id"
    t.json     "status"
    t.json     "description"
    t.datetime "made_at"
  end

  add_index "customer_transactions", ["info_type_id"], name: "index_customer_transactions_on_info_type_id", using: :btree
  add_index "customer_transactions", ["user_id"], name: "index_customer_transactions_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "parameters", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.string  "description",    limit: 255
    t.string  "nick_name",      limit: 255
    t.integer "source_type_id"
    t.json    "source"
    t.json    "display"
    t.json    "unit"
  end

  add_index "parameters", ["source_type_id"], name: "index_parameters_on_source_type_id", using: :btree

  create_table "price_formulas", force: :cascade do |t|
    t.string   "name",                limit: 255
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

  create_table "price_lists", force: :cascade do |t|
    t.string   "name",                            limit: 255
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

  create_table "price_standard_formulas", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.json    "formula"
    t.integer "price_unit_id"
    t.integer "volume_id"
    t.integer "volume_unit_id"
    t.text    "description"
  end

  add_index "price_standard_formulas", ["name"], name: "index_price_standard_formulas_on_name", using: :btree

  create_table "relations", force: :cascade do |t|
    t.integer "type_id"
    t.string  "name",           limit: 255
    t.integer "owner_id"
    t.integer "parent_id"
    t.integer "children",                   default: [], array: true
    t.integer "children_level",             default: 1
  end

  add_index "relations", ["type_id"], name: "index_relations_on_type_id", using: :btree

  create_table "result_agregates", force: :cascade do |t|
    t.integer "run_id"
    t.integer "tarif_id"
    t.string  "service_set_id"
    t.string  "service_category_name"
    t.integer "rouming_ids",           array: true
    t.integer "geo_ids",               array: true
    t.integer "partner_ids",           array: true
    t.integer "calls_ids",             array: true
    t.integer "one_time_ids",          array: true
    t.integer "periodic_ids",          array: true
    t.integer "fix_ids",               array: true
    t.string  "rouming_names",         array: true
    t.string  "geo_names",             array: true
    t.string  "partner_names",         array: true
    t.string  "calls_names",           array: true
    t.string  "one_time_names",        array: true
    t.string  "periodic_names",        array: true
    t.string  "fix_names",             array: true
    t.string  "rouming_details",       array: true
    t.string  "geo_details",           array: true
    t.string  "partner_details",       array: true
    t.float   "price"
    t.integer "call_id_count"
    t.float   "sum_duration_minute"
    t.float   "sum_volume"
    t.integer "count_volume"
  end

  add_index "result_agregates", ["call_id_count"], name: "index_result_agregates_on_call_id_count", using: :btree
  add_index "result_agregates", ["calls_ids"], name: "index_result_agregates_on_calls_ids", using: :btree
  add_index "result_agregates", ["fix_ids"], name: "index_result_agregates_on_fix_ids", using: :btree
  add_index "result_agregates", ["geo_ids"], name: "index_result_agregates_on_geo_ids", using: :btree
  add_index "result_agregates", ["one_time_ids"], name: "index_result_agregates_on_one_time_ids", using: :btree
  add_index "result_agregates", ["partner_ids"], name: "index_result_agregates_on_partner_ids", using: :btree
  add_index "result_agregates", ["periodic_ids"], name: "index_result_agregates_on_periodic_ids", using: :btree
  add_index "result_agregates", ["price"], name: "index_result_agregates_on_price", using: :btree
  add_index "result_agregates", ["rouming_ids"], name: "index_result_agregates_on_rouming_ids", using: :btree
  add_index "result_agregates", ["run_id"], name: "index_result_agregates_on_run_id", using: :btree
  add_index "result_agregates", ["service_category_name"], name: "index_result_agregates_on_service_category_name", using: :btree
  add_index "result_agregates", ["service_set_id"], name: "index_result_agregates_on_service_set_id", using: :btree
  add_index "result_agregates", ["tarif_id"], name: "index_result_agregates_on_tarif_id", using: :btree

  create_table "result_runs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "run"
    t.string  "name"
    t.text    "description"
    t.jsonb   "optimization_params"
    t.jsonb   "service_choices"
    t.jsonb   "services_select"
    t.jsonb   "service_categories_select"
    t.jsonb   "services_for_calculation_select"
  end

  add_index "result_runs", ["run"], name: "index_result_runs_on_run", using: :btree
  add_index "result_runs", ["user_id"], name: "index_result_runs_on_user_id", using: :btree

  create_table "result_service_categories", force: :cascade do |t|
    t.integer "run_id"
    t.integer "tarif_id"
    t.string  "service_set_id"
    t.integer "service_id"
    t.string  "service_category_name"
    t.integer "rouming_ids",           array: true
    t.integer "geo_ids",               array: true
    t.integer "partner_ids",           array: true
    t.integer "calls_ids",             array: true
    t.integer "one_time_ids",          array: true
    t.integer "periodic_ids",          array: true
    t.integer "fix_ids",               array: true
    t.string  "rouming_names",         array: true
    t.string  "geo_names",             array: true
    t.string  "partner_names",         array: true
    t.string  "calls_names",           array: true
    t.string  "one_time_names",        array: true
    t.string  "periodic_names",        array: true
    t.string  "fix_names",             array: true
    t.string  "rouming_details",       array: true
    t.string  "geo_details",           array: true
    t.string  "partner_details",       array: true
    t.float   "price"
    t.integer "call_id_count"
    t.float   "sum_duration_minute"
    t.float   "sum_volume"
    t.integer "count_volume"
  end

  add_index "result_service_categories", ["call_id_count"], name: "index_result_service_categories_on_call_id_count", using: :btree
  add_index "result_service_categories", ["calls_ids"], name: "index_result_service_categories_on_calls_ids", using: :btree
  add_index "result_service_categories", ["fix_ids"], name: "index_result_service_categories_on_fix_ids", using: :btree
  add_index "result_service_categories", ["geo_ids"], name: "index_result_service_categories_on_geo_ids", using: :btree
  add_index "result_service_categories", ["one_time_ids"], name: "index_result_service_categories_on_one_time_ids", using: :btree
  add_index "result_service_categories", ["partner_ids"], name: "index_result_service_categories_on_partner_ids", using: :btree
  add_index "result_service_categories", ["periodic_ids"], name: "index_result_service_categories_on_periodic_ids", using: :btree
  add_index "result_service_categories", ["price"], name: "index_result_service_categories_on_price", using: :btree
  add_index "result_service_categories", ["rouming_ids"], name: "index_result_service_categories_on_rouming_ids", using: :btree
  add_index "result_service_categories", ["run_id"], name: "index_result_service_categories_on_run_id", using: :btree
  add_index "result_service_categories", ["service_category_name"], name: "index_result_service_categories_on_service_category_name", using: :btree
  add_index "result_service_categories", ["service_id"], name: "index_result_service_categories_on_service_id", using: :btree
  add_index "result_service_categories", ["service_set_id"], name: "index_result_service_categories_on_service_set_id", using: :btree
  add_index "result_service_categories", ["tarif_id"], name: "index_result_service_categories_on_tarif_id", using: :btree

  create_table "result_service_sets", force: :cascade do |t|
    t.integer "run_id"
    t.string  "service_set_id"
    t.integer "tarif_id"
    t.integer "operator_id"
    t.integer "common_services",     array: true
    t.integer "tarif_options",       array: true
    t.integer "service_ids",         array: true
    t.integer "identical_services",  array: true
    t.float   "price"
    t.integer "call_id_count"
    t.float   "sum_duration_minute"
    t.float   "sum_volume"
    t.integer "count_volume"
  end

  add_index "result_service_sets", ["call_id_count"], name: "index_result_service_sets_on_call_id_count", using: :btree
  add_index "result_service_sets", ["operator_id"], name: "index_result_service_sets_on_operator_id", using: :btree
  add_index "result_service_sets", ["price"], name: "index_result_service_sets_on_price", using: :btree
  add_index "result_service_sets", ["run_id"], name: "index_result_service_sets_on_run_id", using: :btree
  add_index "result_service_sets", ["service_set_id"], name: "index_result_service_sets_on_service_set_id", using: :btree
  add_index "result_service_sets", ["tarif_id"], name: "index_result_service_sets_on_tarif_id", using: :btree

  create_table "result_services", force: :cascade do |t|
    t.integer "run_id"
    t.integer "tarif_id"
    t.string  "service_set_id"
    t.integer "service_id"
    t.float   "price"
    t.integer "call_id_count"
    t.float   "sum_duration_minute"
    t.float   "sum_volume"
    t.integer "count_volume"
  end

  add_index "result_services", ["call_id_count"], name: "index_result_services_on_call_id_count", using: :btree
  add_index "result_services", ["price"], name: "index_result_services_on_price", using: :btree
  add_index "result_services", ["run_id"], name: "index_result_services_on_run_id", using: :btree
  add_index "result_services", ["service_id"], name: "index_result_services_on_service_id", using: :btree
  add_index "result_services", ["service_set_id"], name: "index_result_services_on_service_set_id", using: :btree
  add_index "result_services", ["tarif_id"], name: "index_result_services_on_tarif_id", using: :btree

  create_table "result_tarifs", force: :cascade do |t|
    t.integer "run_id"
    t.integer "tarif_id"
  end

  add_index "result_tarifs", ["run_id"], name: "index_result_tarifs_on_run_id", using: :btree
  add_index "result_tarifs", ["tarif_id"], name: "index_result_tarifs_on_tarif_id", using: :btree

  create_table "service_categories", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.integer "type_id"
    t.integer "parent_id"
    t.integer "level"
    t.integer "path",                  default: [], array: true
  end

  add_index "service_categories", ["parent_id"], name: "index_service_categories_on_parent_id", using: :btree
  add_index "service_categories", ["path"], name: "index_service_categories_on_path", using: :gin
  add_index "service_categories", ["type_id"], name: "index_service_categories_on_type_id", using: :btree

  create_table "service_category_groups", force: :cascade do |t|
    t.string   "name",           limit: 255
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

  create_table "service_category_tarif_classes", force: :cascade do |t|
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

  create_table "service_criteria", force: :cascade do |t|
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

  create_table "service_priorities", force: :cascade do |t|
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

  create_table "tarif_classes", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "operator_id"
    t.integer  "privacy_id"
    t.integer  "standard_service_id"
    t.json     "features"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "dependency"
  end

  add_index "tarif_classes", ["operator_id"], name: "index_tarif_classes_on_operator_id", using: :btree
  add_index "tarif_classes", ["privacy_id"], name: "index_tarif_classes_on_privacy_id", using: :btree
  add_index "tarif_classes", ["standard_service_id"], name: "index_tarif_classes_on_standard_service_id", using: :btree

  create_table "tarif_lists", force: :cascade do |t|
    t.string   "name",           limit: 255
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

  create_table "tests", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "password_digest",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "description"
    t.integer  "location_id"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip",               limit: 255
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain", limit: 255
    t.string   "search_keyword",   limit: 255
    t.string   "browser",          limit: 255
    t.string   "os",               limit: 255
    t.string   "device_type",      limit: 255
    t.string   "country",          limit: 255
    t.string   "region",           limit: 255
    t.string   "city",             limit: 255
    t.string   "utm_source",       limit: 255
    t.string   "utm_medium",       limit: 255
    t.string   "utm_term",         limit: 255
    t.string   "utm_content",      limit: 255
    t.string   "utm_campaign",     limit: 255
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
