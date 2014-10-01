class CreateMovieActorJoins < ActiveRecord::Migration
  def change
    create_table :movie_actor_joins do |t|
      t.integer :movie_id, null: false
      t.integer :actor_id, null: false
      
      t.timestamps
    end
    add_index :movie_actor_joins, :movie_id
    add_index :movie_actor_joins, :actor_id
    
    add_index :movie_actor_joins, [:actor_id, :movie_id], unique: true      
  end
end
