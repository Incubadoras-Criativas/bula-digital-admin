class ChangeReference < ActiveRecord::Migration[8.1]
  def change
    rename_column :bula_cc_data, :bula_concentracao_composical_id, :bula_id
  end
end
