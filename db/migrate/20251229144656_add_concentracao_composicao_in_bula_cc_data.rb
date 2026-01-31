class AddConcentracaoComposicaoInBulaCcData < ActiveRecord::Migration[8.1]
  def change
    add_column :bula_cc_data, :cc, :string
  end
end
