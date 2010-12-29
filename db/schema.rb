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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101227130442) do

  create_table "articles", :force => true do |t|
    t.string   "author"
    t.string   "author_link"
    t.string   "title"
    t.date     "publish_date"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_habits", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "name",       :null => false
    t.boolean  "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "habits", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "last_completed_date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "common_habit_id"
    t.boolean  "completed",           :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "uid",          :null => false
    t.string   "access_token"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "friend_ids"
  end

  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
