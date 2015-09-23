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

ActiveRecord::Schema.define(version: 20150923153542) do

  create_table "conversions", force: :cascade do |t|
    t.string   "conversion_type"
    t.datetime "enqueue_date"
    t.datetime "start_date"
    t.datetime "end_time"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "image_id"
  end

  add_index "conversions", ["image_id"], name: "index_conversions_on_image_id"

  create_table "images", force: :cascade do |t|
    t.string   "remote_src"
    t.string   "local_src"
    t.string   "resized_src"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "processed_images", force: :cascade do |t|
    t.string   "local_src"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "processed_image_id"
  end

  add_index "processed_images", ["processed_image_id"], name: "index_processed_images_on_processed_image_id"

end
