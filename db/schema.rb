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

ActiveRecord::Schema.define(version: 20150102101917) do

  create_table "gpslocations", force: true do |t|
    t.decimal  "latitude",       precision: 10, scale: 7
    t.decimal  "longitude",      precision: 10, scale: 7
    t.string   "phoneNumber"
    t.string   "userName"
    t.string   "sessionID"
    t.integer  "speed"
    t.integer  "direction"
    t.decimal  "distance",       precision: 10, scale: 1
    t.datetime "gpsTime"
    t.string   "locationMethod"
    t.integer  "accuracy"
    t.string   "extraInfo"
    t.string   "eventType"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gpslocations", ["phoneNumber"], name: "phoneNumberIndex", using: :btree
  add_index "gpslocations", ["sessionID"], name: "sessionIDIndex", using: :btree
  add_index "gpslocations", ["userName"], name: "userNameIndex", using: :btree

end
