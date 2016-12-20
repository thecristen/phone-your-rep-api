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

ActiveRecord::Schema.define(version: 20161220031319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "office_locations", force: :cascade do |t|
    t.integer  "rep_id"
    t.string   "office_type"
    t.string   "line1"
    t.string   "line2"
    t.string   "line3"
    t.string   "line4"
    t.string   "line5"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "phone"
    t.index ["rep_id"], name: "index_office_locations_on_rep_id", using: :btree
  end

  create_table "reps", force: :cascade do |t|
    t.string   "state"
    t.string   "district"
    t.string   "office"
    t.string   "member_full"
    t.string   "name"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "party"
    t.text     "email"
    t.string   "url"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "youtube"
    t.string   "googleplus"
    t.text     "committees"
    t.string   "senate_class"
    t.string   "bioguide_id"
    t.string   "photo"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string   "zip"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "city"
  end

end
