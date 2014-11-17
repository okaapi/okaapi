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

ActiveRecord::Schema.define(version: 20141117185026) do

  create_table "auth_user_actions", force: true do |t|
    t.integer  "user_session_id"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "params"
  end

  add_index "auth_user_actions", ["user_session_id"], name: "index_auth_user_actions_on_user_session_id", using: :btree

  create_table "auth_user_sessions", force: true do |t|
    t.integer  "user_id"
    t.string   "client"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_user_sessions", ["user_id"], name: "index_auth_user_sessions_on_user_id", using: :btree

  create_table "auth_users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "token"
    t.string   "role",            default: "user"
    t.string   "active",          default: "unconfirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "diary_service",   default: "off"
    t.string   "alternate_email"
  end

  create_table "diary_entries", force: true do |t|
    t.datetime "date"
    t.integer  "day",        default: 0
    t.integer  "month",      default: 0
    t.integer  "year",       default: 0
    t.text     "content"
    t.text     "from"
    t.string   "archived",   default: "false"
    t.integer  "user_id",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "g",          default: "false"
  end

  create_table "okaapis", force: true do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "time"
    t.string   "from"
    t.string   "reminder",   default: "0"
    t.string   "archived",   default: "false"
    t.integer  "user_id",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "g",          default: "false"
  end

  create_table "words", force: true do |t|
    t.string   "term"
    t.integer  "priority",   default: 0
    t.string   "person",     default: "false"
    t.string   "archived",   default: "false"
    t.integer  "user_id",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
