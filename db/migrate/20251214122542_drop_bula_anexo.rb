class DropBulaAnexo < ActiveRecord::Migration[8.1]
  def change
    drop_table :bula_anexos
  end
end
