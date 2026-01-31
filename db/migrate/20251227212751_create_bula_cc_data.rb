class CreateBulaCcData < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_cc_data do |t|
      t.belongs_to :bula_concentracao_composical, null: false, foreign_key: true
      t.string :laboratorio
      t.string :indicacoes
      t.string :dosagens
      t.date :data_publicacao
      t.string :fonte
      t.datetime :data_processamento
      t.string :aviso_legal

      t.timestamps
    end
  end
end
