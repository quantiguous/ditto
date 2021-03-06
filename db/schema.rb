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

ActiveRecord::Schema.define(version: 20171025063153) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_roles", ["name", "resource_type", "resource_id"], name: "index_admin_roles_on_name_and_resource_type_and_resource_id"
  add_index "admin_roles", ["name"], name: "index_admin_roles_on_name"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "unique_session_id",      limit: 20
    t.boolean  "inactive",                          default: false
    t.integer  "failed_attempts",                   default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "admin_users_admin_roles", id: false, force: :cascade do |t|
    t.integer "admin_user_id"
    t.integer "admin_role_id"
  end

  add_index "admin_users_admin_roles", ["admin_user_id", "admin_role_id"], name: "index_on_user_roles"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "matchers", force: :cascade do |t|
    t.integer  "route_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "name"
    t.string   "scenario"
    t.integer  "xsl_id"
    t.string   "matcher_type", default: "Matcher", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.string   "expression"
    t.string   "value"
    t.string   "eval_criteria"
    t.integer  "matcher_id"
    t.integer  "response_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "kind"
    t.string   "apply_on",      default: "REQUEST", null: false
  end

  create_table "nonces", force: :cascade do |t|
    t.integer  "route_id",       null: false
    t.integer  "matcher_id",     null: false
    t.string   "nonce_value",    null: false
    t.datetime "created_at",     null: false
    t.datetime "expire_at",      null: false
    t.integer  "request_log_id"
  end

  add_index "nonces", ["route_id", "nonce_value"], name: "uk_nonces_1", unique: true

  create_table "request_logs", force: :cascade do |t|
    t.string   "route_id"
    t.text     "request"
    t.string   "status_code"
    t.string   "accept"
    t.string   "http_method"
    t.string   "content_type"
    t.string   "kind"
    t.text     "response"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "headers"
    t.string   "rep_content_type", limit: 100
  end

  add_index "request_logs", ["route_id"], name: "request_logs_01"

  create_table "responses", force: :cascade do |t|
    t.text     "response"
    t.string   "content_type"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "matcher_id"
    t.integer  "match_id"
    t.integer  "xml_validator_id"
    t.string   "status_code"
    t.integer  "xsl_id"
    t.string   "fault_code",       limit: 100
    t.string   "fault_reason",     limit: 400
    t.string   "kind",             limit: 100, default: "response_body", null: false
    t.string   "xsl_on_kind"
    t.string   "xsl_on_value"
    t.string   "xsl_params"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "routes", force: :cascade do |t|
    t.string   "uri",                                                 null: false
    t.string   "kind"
    t.string   "http_method"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "operation_name"
    t.integer  "xml_validator_id"
    t.string   "enforce_http_basic_auth", limit: 1
    t.string   "username",                limit: 50
    t.string   "password",                limit: 100
    t.integer  "system_id",                                           null: false
    t.boolean  "hidden",                              default: false
    t.integer  "nonce_matcher_id"
    t.integer  "chained_route_id"
    t.integer  "chain_matcher_id"
    t.integer  "nonce_expire_after"
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",       limit: 100, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "systems", force: :cascade do |t|
    t.string   "name",       limit: 100, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "test_cases", force: :cascade do |t|
    t.string   "scenario",   limit: 255, null: false
    t.integer  "service_id",             null: false
    t.text     "request",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "inactive",                          default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "unique_session_id",      limit: 20
    t.string   "mobile_no"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

  create_table "xml_validators", force: :cascade do |t|
    t.text    "xml_schema"
    t.integer "route_id"
    t.string  "name"
  end

  add_index "xml_validators", ["name"], name: "index_xml_validators_on_name", unique: true

  create_table "xsls", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.text   "xsl",              null: false
  end

end
