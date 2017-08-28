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

ActiveRecord::Schema.define(version: 20170825202844) do

  create_table "gemfiles", force: :cascade do |t|
    t.integer "ruby_app_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ruby_app_id"], name: "index_gemfiles_on_ruby_app_id", unique: true
  end

  create_table "ruby_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "repo_url", null: false
    t.integer "api_type", default: 1, null: false
    t.text "api_data"
    t.datetime "last_check"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ruby_version"
    t.index ["last_check"], name: "index_ruby_apps_on_last_check"
    t.index ["name"], name: "index_ruby_apps_on_name", unique: true
    t.index ["repo_url"], name: "index_ruby_apps_on_repo_url", unique: true
  end

  create_table "ruby_gem_data", force: :cascade do |t|
    t.string "name", null: false
    t.text "versions"
    t.boolean "skip", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ruby_gem_data_on_name", unique: true
    t.index ["updated_at"], name: "index_ruby_gem_data_on_updated_at"
  end

  create_table "ruby_versions", force: :cascade do |t|
    t.string "version", null: false
    t.date "released"
    t.string "notes_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["version"], name: "index_ruby_versions_on_version", unique: true
  end

end
