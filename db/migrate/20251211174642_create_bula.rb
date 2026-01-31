class CreateBula < ActiveRecord::Migration[8.1]
  def change
    create_table :bulas do |t|
      t.belongs_to :bula_grupo, null: false, foreign_key: true
      t.string :denominacao
      t.string :concentracao_composicao
      t.string :forma
      t.string :atc

      t.timestamps
    end
  end
end
