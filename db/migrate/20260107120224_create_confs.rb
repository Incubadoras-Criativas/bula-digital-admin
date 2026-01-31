class CreateConfs < ActiveRecord::Migration[8.1]
  def change
    create_table :confs do |t|
      t.belongs_to :app_info, null: false, foreign_key: true
      t.string :nome
      t.string :value
      t.boolean :as_attachment
      t.jsonb :obj

      t.timestamps
    end
  end
end
