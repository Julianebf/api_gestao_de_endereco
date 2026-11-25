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

ActiveRecord::Schema[7.1].define(version: 2026_11_24_141500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "label", limit: 80
    t.string "cep", limit: 8, null: false
    t.string "street", limit: 150, null: false
    t.string "number", limit: 20, null: false
    t.string "complement", limit: 100
    t.string "neighborhood", limit: 100, null: false
    t.string "city", limit: 100, null: false
    t.string "state", limit: 2, null: false
    t.string "country", limit: 60, default: "Brasil", null: false
    t.boolean "primary", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cep"], name: "index_addresses_on_cep"
    t.index ["city"], name: "index_addresses_on_city"
    t.index ["primary"], name: "index_addresses_on_single_primary", unique: true, where: "(\"primary\" = true)"
    t.index ["state"], name: "index_addresses_on_state"
  end

end
