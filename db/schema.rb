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

ActiveRecord::Schema.define(version: 20161117230854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string  "type"
    t.text    "text"
    t.integer "expansion_id"
    t.index ["expansion_id"], name: "index_cards_on_expansion_id", using: :btree
  end

  create_table "expansions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_user_id"
    t.index ["friend_user_id", "user_id"], name: "index_friendships_on_friend_user_id_and_user_id", using: :btree
    t.index ["user_id", "friend_user_id"], name: "index_friendships_on_user_id_and_friend_user_id", using: :btree
  end

  create_table "game_lobbies", force: :cascade do |t|
    t.string   "name"
    t.boolean  "private"
    t.string   "token"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_game_lobbies_on_token", using: :btree
  end

  create_table "game_lobby_users", force: :cascade do |t|
    t.integer "game_lobby_id"
    t.integer "user_id"
    t.boolean "moderator"
    t.boolean "admin"
    t.index ["game_lobby_id"], name: "index_game_lobby_users_on_game_lobby_id", using: :btree
    t.index ["user_id"], name: "index_game_lobby_users_on_user_id", using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.integer  "score_limit"
    t.integer  "game_lobby_id"
    t.integer  "winning_user_id"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["game_lobby_id"], name: "index_games_on_game_lobby_id", using: :btree
    t.index ["status"], name: "index_games_on_status", using: :btree
    t.index ["winning_user_id"], name: "index_games_on_winning_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "game_lobby_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["game_lobby_id"], name: "index_messages_on_game_lobby_id", using: :btree
  end

  create_table "player_cards", force: :cascade do |t|
    t.integer "player_id"
    t.integer "card_id"
    t.integer "round_id"
    t.index ["card_id"], name: "index_player_cards_on_card_id", using: :btree
    t.index ["player_id"], name: "index_player_cards_on_player_id", using: :btree
    t.index ["round_id"], name: "index_player_cards_on_round_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.integer "score"
    t.integer "order"
    t.index ["game_id"], name: "index_players_on_game_id", using: :btree
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "number"
    t.integer  "bard_player_id"
    t.integer  "winning_player_id"
    t.integer  "first_pc_id"
    t.integer  "second_pc_id"
    t.integer  "third_pc_id"
    t.integer  "story_card_id"
    t.string   "status"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["game_id"], name: "index_rounds_on_game_id", using: :btree
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
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["username"], name: "index_users_on_username", using: :btree
  end

end
