class CreateUids < ActiveRecord::Migration[8.1]
  def change
    create_table :uids do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :uid
      t.jsonb :identifier

      t.timestamps

      t.index :uid, unique: true
    end
  end
end
