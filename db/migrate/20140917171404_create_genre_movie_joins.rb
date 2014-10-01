class CreateGenreMovieJoins < ActiveRecord::Migration
  def change
    create_table :genre_movie_joins do |t|
      t.integer :movie_id, null: false
      t.integer :genre_id, null: false

      t.timestamps
    end
    add_index :genre_movie_joins, :movie_id
    add_index :genre_movie_joins, :genre_id
    
    add_index :genre_movie_joins, [:genre_id, :movie_id], unique: true    
  end
end
