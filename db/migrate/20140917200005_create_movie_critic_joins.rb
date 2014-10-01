class CreateMovieCriticJoins < ActiveRecord::Migration
  def change
    create_table :movie_critic_joins do |t|
      t.string :critic_name
      t.integer :movie_id

      t.string :freshness
      t.string :publication
      t.text :quote
      t.string :review_link

      t.timestamps
    end
    add_index :movie_critic_joins, :movie_id
    add_index :movie_critic_joins, [:critic_name, :movie_id], unique: true      
  end
end
