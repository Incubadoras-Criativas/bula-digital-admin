class CreateBulaIndicacao < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_indicacaos do |t|
      t.string :indicacao

      t.timestamps
    end
  end
end
