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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130318205657) do

  create_table "bugs", :force => true do |t|
    t.string   "status"
    t.string   "drop_folder"
    t.integer  "requestor_id"
    t.integer  "tester_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "tfs_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "cc"
    t.datetime "date"
    t.string   "subject"
    t.string   "body"
    t.string   "raw_body"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "emails_users", :id => false, :force => true do |t|
    t.integer "email_id"
    t.integer "user_id"
  end

  add_index "emails_users", ["email_id", "user_id"], :name => "index_emails_users_on_email_id_and_user_id"
  add_index "emails_users", ["user_id", "email_id"], :name => "index_emails_users_on_user_id_and_email_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "role"
  end

end
