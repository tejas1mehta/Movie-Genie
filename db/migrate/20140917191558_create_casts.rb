class CreateCasts < ActiveRecord::Migration
  def change
    create_table :casts do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :casts, :name, unique: true    
  end
end
