class CreateUsers < ActiveRecord::Migration[8.1]
    def change
      create_table :users do |u|
        u.string :name, null:false
        u.string :email, null:false
        u.string :password_digest, null:false
      end
      add_index :users, :email, unique:true
    end
end