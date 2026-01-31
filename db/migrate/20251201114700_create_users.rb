class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :nome
      t.string :email
      t.string :nickname
      t.date :nascimento
      t.string :password_digest

      t.timestamps
    end
  end
end
