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

ActiveRecord::Schema.define(version: 20131019130539) do

  create_table "anns", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boards", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "locations", force: true do |t|
    t.integer  "panel_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x"
    t.integer  "y"
    t.integer  "item_id"
    t.string   "item_type"
  end

  create_table "logins", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "panels", force: true do |t|
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "board_id"
    t.integer  "_height"
    t.integer  "_width"
    t.string   "name"
  end

  create_table "procedures", force: true do |t|
    t.string   "path"
    t.integer  "ann_id"
    t.integer  "revision"
    t.datetime "revised_on", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.string   "keywords"
    t.string   "kind"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
