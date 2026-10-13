class CreateUsers < ActiveRecord::Migration[8.1]
    def change
      create_table :users do |u|
        u.string :name, null:false
        u.string :email, null:false
        u.string :password, null:false
      end
      add_index :users, :isbn, unique:true
    end
end