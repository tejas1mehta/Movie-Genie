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

ActiveRecord::Schema.define(version: 20140917202938) do

  create_table "casts", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "casts", ["name"], name: "index_casts_on_name", unique: true

  create_table "genre_movie_joins", force: true do |t|
    t.integer  "movie_id",   null: false
    t.integer  "genre_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genre_movie_joins", ["genre_id", "movie_id"], name: "index_genre_movie_joins_on_genre_id_and_movie_id", unique: true
  add_index "genre_movie_joins", ["genre_id"], name: "index_genre_movie_joins_on_genre_id"
  add_index "genre_movie_joins", ["movie_id"], name: "index_genre_movie_joins_on_movie_id"

  create_table "genres", force: true do |t|
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_actor_joins", force: true do |t|
    t.integer  "movie_id",   null: false
    t.integer  "actor_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movie_actor_joins", ["actor_id", "movie_id"], name: "index_movie_actor_joins_on_actor_id_and_movie_id", unique: true
  add_index "movie_actor_joins", ["actor_id"], name: "index_movie_actor_joins_on_actor_id"
  add_index "movie_actor_joins", ["movie_id"], name: "index_movie_actor_joins_on_movie_id"

  create_table "movie_critic_joins", force: true do |t|
    t.string   "critic_name"
    t.integer  "movie_id"
    t.string   "freshness"
    t.string   "publication"
    t.text     "quote"
    t.string   "review_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movie_critic_joins", ["critic_name", "movie_id"], name: "index_movie_critic_joins_on_critic_name_and_movie_id", unique: true
  add_index "movie_critic_joins", ["movie_id"], name: "index_movie_critic_joins_on_movie_id"

  create_table "movie_director_joins", force: true do |t|
    t.integer  "movie_id",    null: false
    t.integer  "director_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movie_director_joins", ["director_id", "movie_id"], name: "index_movie_director_joins_on_director_id_and_movie_id", unique: true
  add_index "movie_director_joins", ["director_id"], name: "index_movie_director_joins_on_director_id"
  add_index "movie_director_joins", ["movie_id"], name: "index_movie_director_joins_on_movie_id"

  create_table "movie_studio_joins", force: true do |t|
    t.integer  "movie_id",   null: false
    t.integer  "studio_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movie_studio_joins", ["movie_id"], name: "index_movie_studio_joins_on_movie_id"
  add_index "movie_studio_joins", ["studio_id", "movie_id"], name: "index_movie_studio_joins_on_studio_id_and_movie_id", unique: true
  add_index "movie_studio_joins", ["studio_id"], name: "index_movie_studio_joins_on_studio_id"

  create_table "movie_writer_joins", force: true do |t|
    t.integer  "movie_id",   null: false
    t.integer  "writer_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movie_writer_joins", ["movie_id"], name: "index_movie_writer_joins_on_movie_id"
  add_index "movie_writer_joins", ["writer_id", "movie_id"], name: "index_movie_writer_joins_on_writer_id_and_movie_id", unique: true
  add_index "movie_writer_joins", ["writer_id"], name: "index_movie_writer_joins_on_writer_id"

  create_table "movies", force: true do |t|
    t.string   "title",                                                          null: false
    t.datetime "theatre_release_date"
    t.datetime "dvd_release_date"
    t.string   "imdb_id"
    t.integer  "rt_id"
    t.string   "years_running"
    t.boolean  "television_show"
    t.boolean  "bollywood"
    t.boolean  "in_theatre",            default: false
    t.string   "photo_link",            default: "assets/Image_Unavailable.png"
    t.text     "plot"
    t.string   "countries"
    t.string   "awards"
    t.integer  "run_time"
    t.string   "youtube_trailer_title"
    t.string   "youtube_trailer"
    t.integer  "rt_audience_score"
    t.integer  "rt_critics_score"
    t.float    "imdb_rating"
    t.integer  "imdb_votes"
    t.float    "avg_rating"
    t.float    "avg_rating_half_scale"
    t.string   "mpaa_rating"
    t.float    "genre0",                default: 0.0
    t.float    "genre1",                default: 0.0
    t.float    "genre2",                default: 0.0
    t.float    "genre3",                default: 0.0
    t.float    "genre4",                default: 0.0
    t.float    "genre5",                default: 0.0
    t.float    "genre6",                default: 0.0
    t.float    "genre8",                default: 0.0
    t.float    "genre7",                default: 0.0
    t.float    "genre9",                default: 0.0
    t.float    "genre10",               default: 0.0
    t.float    "genre11",               default: 0.0
    t.float    "genre12",               default: 0.0
    t.float    "genre13",               default: 0.0
    t.float    "genre14",               default: 0.0
    t.float    "genre15",               default: 0.0
    t.float    "genre16",               default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["title"], name: "index_movies_on_title", unique: true

  create_table "studios", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "studios", ["name"], name: "index_studios_on_name", unique: true

  create_table "user_list_joins", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "movie_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_list_joins", ["user_id", "movie_id"], name: "index_user_list_joins_on_user_id_and_movie_id", unique: true
  add_index "user_list_joins", ["user_id"], name: "index_user_list_joins_on_user_id"

  create_table "user_not_interested_joins", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "movie_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_not_interested_joins", ["user_id", "movie_id"], name: "index_user_not_interested_joins_on_user_id_and_movie_id", unique: true
  add_index "user_not_interested_joins", ["user_id"], name: "index_user_not_interested_joins_on_user_id"

  create_table "user_rating_joins", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "movie_id",     null: false
    t.integer  "movie_rating", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_rating_joins", ["user_id", "movie_id"], name: "index_user_rating_joins_on_user_id_and_movie_id", unique: true
  add_index "user_rating_joins", ["user_id"], name: "index_user_rating_joins_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_token"
    t.string   "session_token"
    t.string   "provider"
    t.string   "uid"
    t.integer  "zipcode"
    t.boolean  "genres_saved",   default: false
    t.float    "genre0",         default: 0.0
    t.float    "genre1",         default: 0.0
    t.float    "genre2",         default: 0.0
    t.float    "genre3",         default: 0.0
    t.float    "genre4",         default: 0.0
    t.float    "genre5",         default: 0.0
    t.float    "genre6",         default: 0.0
    t.float    "genre8",         default: 0.0
    t.float    "genre7",         default: 0.0
    t.float    "genre9",         default: 0.0
    t.float    "genre10",        default: 0.0
    t.float    "genre11",        default: 0.0
    t.float    "genre12",        default: 0.0
    t.float    "genre13",        default: 0.0
    t.float    "genre14",        default: 0.0
    t.float    "genre15",        default: 0.0
    t.float    "genre16",        default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["session_token"], name: "index_users_on_session_token", unique: true

end
