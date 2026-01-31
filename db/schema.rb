# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_07_120224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "nickname"
    t.string "nome"
    t.string "password_digest"
    t.integer "role", limit: 2, default: 0
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["nickname"], name: "index_admins_on_nickname", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.bigint "user_id"
    t.bigint "visit_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "app_version"
    t.string "browser"
    t.string "city"
    t.string "country"
    t.string "device_type"
    t.string "ip"
    t.text "landing_page"
    t.float "latitude"
    t.float "longitude"
    t.string "os"
    t.string "os_version"
    t.string "platform"
    t.text "referrer"
    t.string "referring_domain"
    t.string "region"
    t.datetime "started_at"
    t.text "user_agent"
    t.bigint "user_id"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_medium"
    t.string "utm_source"
    t.string "utm_term"
    t.string "visit_token"
    t.string "visitor_token"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
    t.index ["visitor_token", "started_at"], name: "index_ahoy_visits_on_visitor_token_and_started_at"
  end

  create_table "app_infos", force: :cascade do |t|
    t.string "app_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bula_anexos", force: :cascade do |t|
    t.bigint "bula_concentracao_composical_id", null: false
    t.datetime "created_at", null: false
    t.string "laboratorio"
    t.datetime "updated_at", null: false
    t.index ["bula_concentracao_composical_id"], name: "index_bula_anexos_on_bula_concentracao_composical_id"
  end

  create_table "bula_bula_indicacaos", id: false, force: :cascade do |t|
    t.bigint "bula_id"
    t.bigint "bula_indicacao_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bula_id"], name: "index_bula_bula_indicacaos_on_bula_id"
    t.index ["bula_indicacao_id"], name: "index_bula_bula_indicacaos_on_bula_indicacao_id"
  end

  create_table "bula_cc_data", force: :cascade do |t|
    t.string "aviso_legal"
    t.bigint "bula_id", null: false
    t.string "cc"
    t.datetime "created_at", null: false
    t.datetime "data_processamento"
    t.date "data_publicacao"
    t.string "dosagens"
    t.string "fonte"
    t.string "forma"
    t.string "indicacoes"
    t.string "laboratorio"
    t.datetime "updated_at", null: false
    t.index ["bula_id"], name: "index_bula_cc_data_on_bula_id"
  end

  create_table "bula_cc_indicacaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "indicacao"
    t.datetime "updated_at", null: false
  end

  create_table "bula_concentracao_composicals", force: :cascade do |t|
    t.string "atc"
    t.bigint "bula_id", null: false
    t.string "concentracao_composicao"
    t.datetime "created_at", null: false
    t.string "forma"
    t.datetime "updated_at", null: false
    t.index ["bula_id"], name: "index_bula_concentracao_composicals_on_bula_id"
  end

  create_table "bula_grupos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "sigla"
    t.datetime "updated_at", null: false
  end

  create_table "bula_indicacaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "indicacao"
    t.datetime "updated_at", null: false
  end

  create_table "bulas", force: :cascade do |t|
    t.bigint "bula_grupo_id", null: false
    t.datetime "created_at", null: false
    t.string "denominacao"
    t.datetime "updated_at", null: false
    t.index ["bula_grupo_id"], name: "index_bulas_on_bula_grupo_id"
  end

  create_table "cc_indicacaos", force: :cascade do |t|
    t.bigint "bula_concentracao_composical_id", null: false
    t.datetime "created_at", null: false
    t.bigint "indicacao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["bula_concentracao_composical_id"], name: "index_cc_indicacaos_on_bula_concentracao_composical_id"
    t.index ["indicacao_id"], name: "index_cc_indicacaos_on_indicacao_id"
  end

  create_table "confs", force: :cascade do |t|
    t.bigint "app_info_id", null: false
    t.boolean "as_attachment"
    t.datetime "created_at", null: false
    t.string "nome"
    t.jsonb "obj"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["app_info_id"], name: "index_confs_on_app_info_id"
  end

  create_table "indicacaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "indicacao"
    t.datetime "updated_at", null: false
  end

  create_table "status_pdf_bulas", force: :cascade do |t|
    t.bigint "blob_id"
    t.datetime "created_at", null: false
    t.jsonb "ia_response"
    t.boolean "match", default: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["blob_id"], name: "index_status_pdf_bulas_on_blob_id", unique: true
  end

  create_table "uids", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "identifier"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["uid"], name: "index_uids_on_uid", unique: true
    t.index ["user_id"], name: "index_uids_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.date "nascimento"
    t.string "nickname"
    t.string "nome"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bula_anexos", "bula_concentracao_composicals"
  add_foreign_key "bula_cc_data", "bula_concentracao_composicals", column: "bula_id"
  add_foreign_key "bula_concentracao_composicals", "bulas"
  add_foreign_key "bulas", "bula_grupos"
  add_foreign_key "cc_indicacaos", "bula_concentracao_composicals"
  add_foreign_key "cc_indicacaos", "indicacaos"
  add_foreign_key "confs", "app_infos"
  add_foreign_key "uids", "users"
end
