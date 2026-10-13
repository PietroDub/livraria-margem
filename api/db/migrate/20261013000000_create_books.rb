class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :category, null: false
      t.string :isbn, null: false
      t.integer :price_cents, null: false, default: 0
      t.integer :stock, null: false, default: 0
      t.text :description, null: false, default: ''
      t.timestamps
    end
    add_index :books, :isbn, unique: true
    add_check_constraint :books, 'stock >= 0', name: 'books_stock_nonnegative'
    add_check_constraint :books, 'price_cents >= 0', name: 'books_price_nonnegative'
  end
end
