class CreateMovieStudioJoins < ActiveRecord::Migration
  def change
    create_table :movie_studio_joins do |t|
      t.integer :movie_id, null: false
      t.integer :studio_id, null: false
      
      t.timestamps
    end
    add_index :movie_studio_joins, :movie_id
    add_index :movie_studio_joins, :studio_id
    
    add_index :movie_studio_joins, [:studio_id, :movie_id], unique: true   
  end
end
