class AddUserToBooks < ActiveRecord::Migration[8.1]
  def change
    # FK opcional: livros do seed/catálogo podem existir sem dono.
    add_reference :books, :user, foreign_key: true
  end
end
