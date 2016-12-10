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

ActiveRecord::Schema.define(version: 20161210205102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree
  end

  create_table "cards", force: :cascade do |t|
    t.string  "type"
    t.text    "text"
    t.integer "expansion_id"
    t.string  "uuid"
    t.index ["expansion_id"], name: "index_cards_on_expansion_id", using: :btree
    t.index ["uuid"], name: "index_cards_on_uuid", using: :btree
  end

  create_table "expansions", force: :cascade do |t|
    t.string   "name"
    t.string   "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_expansions_on_uuid", using: :btree
  end

  create_table "friendships", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_user_id"
    t.index ["friend_user_id", "user_id"], name: "index_friendships_on_friend_user_id_and_user_id", using: :btree
    t.index ["user_id", "friend_user_id"], name: "index_friendships_on_user_id_and_friend_user_id", using: :btree
  end

  create_table "game_expansions", id: false, force: :cascade do |t|
    t.integer "game_id"
    t.integer "expansion_id"
    t.index ["expansion_id"], name: "index_game_expansions_on_expansion_id", using: :btree
    t.index ["game_id"], name: "index_game_expansions_on_game_id", using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.integer  "score_limit"
    t.integer  "lobby_id"
    t.integer  "winning_user_id"
    t.string   "status"
    t.string   "guid"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["guid"], name: "index_games_on_guid", using: :btree
    t.index ["lobby_id"], name: "index_games_on_lobby_id", using: :btree
    t.index ["status"], name: "index_games_on_status", using: :btree
    t.index ["winning_user_id"], name: "index_games_on_winning_user_id", using: :btree
  end

  create_table "lobbies", force: :cascade do |t|
    t.string   "name"
    t.boolean  "private"
    t.string   "token"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["token"], name: "index_lobbies_on_token", using: :btree
  end

  create_table "lobby_users", force: :cascade do |t|
    t.integer  "lobby_id"
    t.integer  "user_id"
    t.boolean  "moderator"
    t.boolean  "admin"
    t.datetime "deleted_at"
    t.string   "guid"
    t.string   "name"
    t.index ["guid"], name: "index_lobby_users_on_guid", using: :btree
    t.index ["lobby_id"], name: "index_lobby_users_on_lobby_id", using: :btree
    t.index ["user_id"], name: "index_lobby_users_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "lobby_id"
    t.integer  "user_id"
    t.text     "message"
    t.string   "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_messages_on_guid", using: :btree
    t.index ["lobby_id"], name: "index_messages_on_lobby_id", using: :btree
  end

  create_table "player_cards", force: :cascade do |t|
    t.integer "player_id"
    t.integer "card_id"
    t.integer "round_id"
    t.string  "guid"
    t.index ["card_id"], name: "index_player_cards_on_card_id", using: :btree
    t.index ["guid"], name: "index_player_cards_on_guid", using: :btree
    t.index ["player_id"], name: "index_player_cards_on_player_id", using: :btree
    t.index ["round_id"], name: "index_player_cards_on_round_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "score"
    t.integer  "order"
    t.string   "guid"
    t.datetime "deleted_at"
    t.index ["game_id"], name: "index_players_on_game_id", using: :btree
    t.index ["guid"], name: "index_players_on_guid", using: :btree
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "number"
    t.integer  "bard_player_id"
    t.integer  "winning_player_id"
    t.integer  "fool_pc_id"
    t.integer  "crisis_pc_id"
    t.integer  "bad_decision_pc_id"
    t.integer  "story_card_id"
    t.string   "status"
    t.string   "guid"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["game_id"], name: "index_rounds_on_game_id", using: :btree
    t.index ["guid"], name: "index_rounds_on_guid", using: :btree
    t.index ["winning_player_id"], name: "index_rounds_on_winning_player_id", using: :btree
  end

  create_table "user_expansions", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "expansion_id"
    t.index ["expansion_id", "user_id"], name: "index_user_expansions_on_expansion_id_and_user_id", using: :btree
    t.index ["user_id", "expansion_id"], name: "index_user_expansions_on_user_id_and_expansion_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "display_name"
    t.string   "password_digest"
    t.string   "uuid"
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["username"], name: "index_users_on_username", using: :btree
    t.index ["uuid"], name: "index_users_on_uuid", using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree
  end

end
