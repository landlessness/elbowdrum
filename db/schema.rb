# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090107213756) do

  create_table "account_memberships", :force => true do |t|
    t.integer  "account_id"
    t.integer  "person_id"
    t.boolean  "administrator", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "screen_name"
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "email"
    t.string   "confirmation_code"
    t.integer  "person_id"
    t.datetime "confirmed_at"
    t.string   "state",             :default => "passive"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "account_membership_id"
    t.string   "text"
    t.string   "type"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.date     "for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.string   "time_zone"
    t.integer  "current_email_id"
  end

  add_index "people", ["login"], :name => "index_people_on_login", :unique => true

  create_table "team_memberships", :force => true do |t|
    t.integer  "team_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
