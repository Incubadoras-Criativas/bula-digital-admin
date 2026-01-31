class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.string :nome
      t.string :email
      t.string :nickname
      t.string :password_digest
      t.integer :role, limit: 2, default: 0

      t.timestamps
    end
    add_index :admins, :email, unique: true
    add_index :admins, :nickname, unique: true
  end
end
