class CreateMovieDirectorJoins < ActiveRecord::Migration
  def change
    create_table :movie_director_joins do |t|
      t.integer :movie_id, null: false
      t.integer :director_id, null: false
      
      t.timestamps
    end
    add_index :movie_director_joins, :movie_id
    add_index :movie_director_joins, :director_id
    
    add_index :movie_director_joins, [:director_id, :movie_id], unique: true  
  end
end
