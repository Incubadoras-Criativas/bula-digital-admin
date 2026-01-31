class CreateBulaConcentracaoComposicals < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_concentracao_composicals do |t|
      t.belongs_to :bula, null: false, foreign_key: true
      t.string :concentacao_composicao
      t.string :forma
      t.string :atc

      t.timestamps
    end
  end
end
