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

ActiveRecord::Schema.define(version: 2018_06_02_133013) do

  create_table "application_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clusters", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "guid"
    t.string "name"
    t.string "dir_name"
    t.string "file_name"
    t.string "ptype"
    t.binary "csproj_file", limit: 1048576
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "project_ref_id"
    t.index ["project_id", "project_ref_id"], name: "projects_projects_unique_index", unique: true
  end

  create_table "projects_solutions", force: :cascade do |t|
    t.integer "solution_id"
    t.integer "project_id"
    t.index ["project_id"], name: "index_projects_solutions_on_project_id"
    t.index ["solution_id", "project_id"], name: "projects_solutions_unique_index", unique: true
    t.index ["solution_id"], name: "index_projects_solutions_on_solution_id"
  end

  create_table "roehl_applications", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type"
  end

  create_table "roehl_applications_servers", force: :cascade do |t|
    t.integer "roehl_application_id"
    t.integer "server_id"
    t.index ["roehl_application_id", "server_id"], name: "roehl_applications_servers_unique_index", unique: true
    t.index ["roehl_application_id"], name: "index_roehl_applications_servers_on_roehl_application_id"
    t.index ["server_id"], name: "index_roehl_applications_servers_on_server_id"
  end

  create_table "servers", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solutions", force: :cascade do |t|
    t.string "guid"
    t.string "name"
    t.string "file_name"
    t.string "dir_name"
    t.binary "sln_file", limit: 1048576
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
