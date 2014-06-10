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

ActiveRecord::Schema.define(version: 20140610124215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["name"], name: "index_courses_on_name", unique: true, using: :btree

  create_table "lessons", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.integer  "course_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["name"], name: "index_lessons_on_name", unique: true, using: :btree

  create_table "timetables", force: true do |t|
    t.integer  "lesson_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timetables", ["lesson_id", "date"], name: "index_timetables_on_lesson_id_and_date", using: :btree

end
