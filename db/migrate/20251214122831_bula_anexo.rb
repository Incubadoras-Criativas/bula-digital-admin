class BulaAnexo < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_anexos do |t|
      t.belongs_to :bula_concentracao_composical, null: false, foreign_key: true
      t.string :laboratorio

      t.timestamps
    end
  end
end
