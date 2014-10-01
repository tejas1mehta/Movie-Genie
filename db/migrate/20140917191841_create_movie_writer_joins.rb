class CreateMovieWriterJoins < ActiveRecord::Migration
  def change
    create_table :movie_writer_joins do |t|
      t.integer :movie_id, null: false
      t.integer :writer_id, null: false
      
      t.timestamps
    end
    add_index :movie_writer_joins, :movie_id
    add_index :movie_writer_joins, :writer_id
    
    add_index :movie_writer_joins, [:writer_id, :movie_id], unique: true  
  end
end
