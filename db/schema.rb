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

ActiveRecord::Schema.define(version: 20140322150649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: true do |t|
    t.integer "base_service_id"
    t.integer "base_subservice_id"
    t.integer "user_id"
    t.json    "own_phone"
    t.json    "partner_phone"
    t.json    "connect"
    t.json    "description"
  end

  add_index "calls", ["base_service_id"], name: "index_calls_on_base_service_id", using: :btree
  add_index "calls", ["base_subservice_id"], name: "index_calls_on_base_subservice_id", using: :btree
  add_index "calls", ["user_id"], name: "index_calls_on_user_id", using: :btree

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

  create_table "tests", force: true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
