class CreateCcIndicacaos < ActiveRecord::Migration[8.1]
  def change
    create_table :cc_indicacaos do |t|
      t.belongs_to :bula_concentracao_composical, null: false, foreign_key: true
      t.belongs_to :indicacao, null: false, foreign_key: true

      t.timestamps
    end
  end
end
