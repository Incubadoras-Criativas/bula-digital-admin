class CreateBulaBulaIndicacaos < ActiveRecord::Migration[8.1]
  def change
    create_table :bula_bula_indicacaos, id: false do |t|
      t.belongs_to :bula
      t.belongs_to :bula_indicacao

      t.timestamps
    end
  end
end
