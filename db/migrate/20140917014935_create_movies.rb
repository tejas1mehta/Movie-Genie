class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.datetime :theatre_release_date
      t.datetime :dvd_release_date
      t.string :imdb_id
      t.integer :rt_id
      t.string :years_running
      t.boolean :television_show
      t.boolean :bollywood
      t.boolean :in_theatre, default: false
      t.string :photo_link, default: "assets/Image_Unavailable.png"

      t.text :plot
      t.string :countries
      t.string :awards
      t.integer :run_time
      t.string :youtube_trailer_title
      t.string :youtube_trailer

      t.integer :rt_audience_score
      t.integer :rt_critics_score
      t.float :imdb_rating
      t.integer :imdb_votes
      t.float :avg_rating
      t.float :avg_rating_half_scale
      t.string :mpaa_rating

      t.float :genre0, default: 0
      t.float :genre1, default: 0
      t.float :genre2, default: 0
      t.float :genre3, default: 0
      t.float :genre4, default: 0
      t.float :genre5, default: 0
      t.float :genre6, default: 0
      t.float :genre8, default: 0
      t.float :genre7, default: 0
      t.float :genre9, default: 0
      t.float :genre10, default: 0
      t.float :genre11, default: 0
      t.float :genre12, default: 0
      t.float :genre13, default: 0
      t.float :genre14, default: 0
      t.float :genre15, default: 0
      t.float :genre16, default: 0

      t.timestamps
    end

    add_index :movies, :title, unique: true
  end
end
