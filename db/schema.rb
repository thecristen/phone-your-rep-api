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

ActiveRecord::Schema.define(version: 20161221232814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "districts", force: :cascade do |t|
    t.integer  "state_id"
    t.string   "code"
    t.string   "state_code"
    t.string   "full_code"
    t.geometry "geom",       limit: {:srid=>0, :type=>"geometry"}
    t.index ["state_id"], name: "index_districts_on_state_id", using: :btree
  end

  create_table "office_locations", force: :cascade do |t|
    t.integer  "rep_id"
    t.string   "office_type"
    t.string   "phone"
    t.string   "line1"
    t.string   "line2"
    t.string   "line3"
    t.string   "line4"
    t.string   "line5"
    t.float    "latitude"
    t.float    "longitude"
    t.geometry "lonlat",      limit: {:srid=>0, :type=>"point"}
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["rep_id"], name: "index_office_locations_on_rep_id", using: :btree
  end

  create_table "reps", force: :cascade do |t|
    t.integer  "district_id"
    t.integer  "state_id"
    t.string   "office"
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
    t.index ["district_id"], name: "index_reps_on_district_id", using: :btree
    t.index ["state_id"], name: "index_reps_on_state_id", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.string   "state_code"
    t.string   "name"
    t.string   "abbr"
    t.geometry "geom",       limit: {:srid=>0, :type=>"geometry"}
  end

end
