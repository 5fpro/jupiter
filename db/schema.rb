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

ActiveRecord::Schema.define(version: 2017_09_16_185816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "authorizations", force: :cascade do |t|
    t.integer "provider"
    t.string "uid"
    t.string "auth_type"
    t.integer "auth_id"
    t.text "auth_data"
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_type", "auth_id", "provider"], name: "index_authorizations_on_auth_type_and_auth_id_and_provider"
    t.index ["auth_type", "auth_id"], name: "index_authorizations_on_auth_type_and_auth_id"
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "sort"
    t.index ["name"], name: "index_categories_on_name"
    t.index ["sort"], name: "index_categories_on_sort"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.string "item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "data"
    t.index ["item_id", "item_type"], name: "index_comments_on_item_id_and_item_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "githubs", force: :cascade do |t|
    t.integer "project_id"
    t.string "webhook_token"
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_token"], name: "index_githubs_on_webhook_token"
  end

  create_table "project_users", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort"
    t.hstore "data"
    t.boolean "archived", default: false
    t.integer "wage"
    t.index ["project_id", "user_id"], name: "index_project_users_on_project_id_and_user_id"
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id", "sort"], name: "index_project_users_on_user_id_and_sort"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "price_of_hour"
    t.string "name"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "data"
    t.index ["owner_id"], name: "index_projects_on_owner_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.integer "minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "data"
    t.integer "record_type"
    t.integer "todo_id"
    t.index ["project_id", "record_type"], name: "index_records_on_project_id_and_record_type"
    t.index ["project_id"], name: "index_records_on_project_id"
    t.index ["todo_id"], name: "index_records_on_todo_id"
    t.index ["user_id", "project_id"], name: "index_records_on_user_id_and_project_id"
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "slack_channels", force: :cascade do |t|
    t.integer "project_id"
    t.boolean "disabled", default: false
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_slack_channels_on_project_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "todos", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.text "desc"
    t.date "last_recorded_on"
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_recorded_at"
    t.integer "sort"
    t.integer "status"
    t.index ["last_recorded_on"], name: "index_todos_on_last_recorded_on"
    t.index ["project_id", "last_recorded_on"], name: "index_todos_on_project_id_and_last_recorded_on"
    t.index ["project_id"], name: "index_todos_on_project_id"
    t.index ["status"], name: "index_todos_on_status"
    t.index ["user_id", "last_recorded_on"], name: "index_todos_on_user_id_and_last_recorded_on"
    t.index ["user_id", "project_id"], name: "index_todos_on_user_id_and_project_id"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "avatar"
    t.hstore "data"
    t.boolean "todos_published", default: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["todos_published"], name: "index_users_on_todos_published"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
