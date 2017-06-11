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

ActiveRecord::Schema.define(version: 20170610044650) do

  create_table "dealers", force: :cascade do |t|
    t.string   "dealer_unify_id"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "vehicle_id"
    t.string   "feature"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id"
  add_index "line_items", ["vehicle_id"], name: "index_line_items_on_vehicle_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "dealer_id"
    t.date     "expect_delivery_date"
    t.string   "status",               default: "ordered"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.date     "fulfill_date"
  end

  add_index "orders", ["dealer_id"], name: "index_orders_on_dealer_id"

  create_table "vehicle_badges", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_models", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer  "vehicle_model_id"
    t.integer  "vehicle_badge_id"
    t.string   "colour"
    t.integer  "inventory_quantity"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "vehicles", ["vehicle_badge_id"], name: "index_vehicles_on_vehicle_badge_id"
  add_index "vehicles", ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id"

end
