class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_token
      t.string :session_token 
      t.string :provider 
      t.string :uid 

      t.integer :zipcode
      
      t.boolean :genres_saved, default: false

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

    add_index :users, :email, unique: true
    add_index :users, :session_token, unique: true 
    add_index :users, [:provider, :uid], unique: true
  end
end
