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

ActiveRecord::Schema.define(version: 20141111214925) do

  create_table "diary_entries", force: :cascade do |t|
    t.datetime "date"
    t.integer  "day",        limit: 4,     default: 0
    t.integer  "month",      limit: 4,     default: 0
    t.integer  "year",       limit: 4,     default: 0
    t.text     "content",    limit: 65535
    t.text     "from",       limit: 65535
    t.string   "archived",   limit: 255,   default: "false"
    t.integer  "user_id",    limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "g",          limit: 255,   default: "false"
  end

  create_table "okaapis", force: :cascade do |t|
    t.string   "subject",    limit: 255
    t.text     "content",    limit: 65535
    t.datetime "time"
    t.string   "from",       limit: 255
    t.string   "reminder",   limit: 255,   default: "0"
    t.string   "archived",   limit: 255,   default: "false"
    t.integer  "user_id",    limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "g",          limit: 255,   default: "false"
  end

  create_table "user_actions", force: :cascade do |t|
    t.integer  "user_session_id", limit: 4
    t.string   "controller",      limit: 255
    t.string   "action",          limit: 255
    t.string   "params",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_actions", ["user_session_id"], name: "index_user_actions_on_user_session_id", using: :btree

  create_table "user_sessions", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "client",     limit: 255
    t.string   "ip",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "email",           limit: 255
    t.string   "alternate_email", limit: 255, default: ""
    t.string   "password_digest", limit: 255
    t.string   "token",           limit: 255
    t.string   "role",            limit: 255, default: "user"
    t.string   "active",          limit: 255, default: "unconfirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "goal",            limit: 255, default: ""
    t.string   "goal_in_subject", limit: 255, default: ""
    t.string   "diary_service",   limit: 255, default: "off"
  end

  create_table "words", force: :cascade do |t|
    t.string   "term",       limit: 255
    t.integer  "priority",   limit: 4,   default: 0
    t.string   "person",     limit: 255, default: "false"
    t.string   "archived",   limit: 255, default: "false"
    t.integer  "user_id",    limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
