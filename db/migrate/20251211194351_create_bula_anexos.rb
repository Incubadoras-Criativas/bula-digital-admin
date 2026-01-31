class CreateBulaAnexos < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_anexos do |t|
      t.belongs_to :bula, null: false, foreign_key: true
      t.string :laboratorio
      t.string :identificacao

      t.timestamps
    end
  end
end
