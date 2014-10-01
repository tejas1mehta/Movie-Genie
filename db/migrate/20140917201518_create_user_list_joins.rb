class CreateUserListJoins < ActiveRecord::Migration
  def change
    create_table :user_list_joins do |t|
      t.integer :user_id, null: false
      t.integer :movie_id, null: false

      t.timestamps
    end

    add_index :user_list_joins, :user_id
    add_index :user_list_joins, [:user_id, :movie_id], unique: true 
  end
end
