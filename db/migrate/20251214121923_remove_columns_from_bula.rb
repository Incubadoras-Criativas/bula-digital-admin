class RemoveColumnsFromBula < ActiveRecord::Migration[8.1]
  def change
    remove_column :bulas, :concentracao_composicao
    remove_column :bulas, :forma
    remove_column :bulas, :atc
  end
end
