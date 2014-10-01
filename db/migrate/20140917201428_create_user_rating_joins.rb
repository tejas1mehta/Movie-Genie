class CreateUserRatingJoins < ActiveRecord::Migration
  def change
    create_table :user_rating_joins do |t|
      t.integer :user_id, null: false
      t.integer :movie_id, null: false
      t.integer :movie_rating, null: false

      t.timestamps
    end

    add_index :user_rating_joins, :user_id
    add_index :user_rating_joins, [:user_id, :movie_id], unique: true    
  end
end
