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

ActiveRecord::Schema.define(version: 2022_09_15_112841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.bigint "value", null: false
    t.index ["value"], name: "index_cards_on_value"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer "card_id"
    t.string "id_feedback", null: false
    t.string "crt_date", null: false
    t.integer "user_id", null: false
    t.string "user_name"
    t.string "user_country"
    t.string "text"
    t.integer "product_valuation", null: false
    t.index ["card_id"], name: "index_feedbacks_on_card_id"
  end

  add_foreign_key "feedbacks", "cards"
end
