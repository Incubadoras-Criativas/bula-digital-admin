class RenameColumnInBulaConcentracaoComposicao < ActiveRecord::Migration[8.1]
  def change
    rename_column :bula_concentracao_composicals, :concentacao_composicao, :concentracao_composicao
  end
end
