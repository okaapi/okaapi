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

ActiveRecord::Schema.define(version: 2018_10_11_143702) do

  create_table "alexas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "intent"
    t.string "slot"
    t.string "skill"
    t.string "request"
    t.string "answer"
    t.string "aux"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diary_entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.datetime "date"
    t.integer "day", default: 0
    t.integer "month", default: 0
    t.integer "year", default: 0
    t.text "content"
    t.text "from"
    t.string "archived", default: "false"
    t.integer "user_id", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "g", default: "false"
  end

  create_table "okaapis", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.datetime "time"
    t.string "from"
    t.string "reminder", default: "0"
    t.string "archived", default: "false"
    t.integer "user_id", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "g", default: "false"
  end

  create_table "site_maps", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "external"
    t.string "internal"
    t.string "aux"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_actions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "user_session_id"
    t.string "controller"
    t.string "action"
    t.string "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "site", default: "localhost"
    t.index ["user_session_id"], name: "index_user_actions_on_user_session_id"
  end

  create_table "user_sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "client"
    t.string "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "site", default: "localhost"
    t.string "remember_digest"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "alternate_email", default: ""
    t.string "password_digest"
    t.string "token"
    t.string "role", default: "user"
    t.string "active", default: "unconfirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "site", default: "localhost"
    t.string "diary_service", default: "off"
    t.string "goal", default: ""
    t.string "goal_in_subject", default: ""
  end

  create_table "words", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "term"
    t.integer "priority", default: 0
    t.string "person", default: "false"
    t.string "archived", default: "false"
    t.integer "user_id", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
