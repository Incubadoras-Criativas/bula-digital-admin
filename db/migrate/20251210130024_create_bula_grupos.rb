class CreateBulaGrupos < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_grupos do |t|
      t.string :sigla
      t.string :descricao

      t.timestamps
    end
  end
end
