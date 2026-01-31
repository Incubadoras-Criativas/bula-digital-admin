class CreateIndicacaos < ActiveRecord::Migration[8.1]
  def change
    create_table :indicacaos do |t|
      t.string :indicacao

      t.timestamps
    end
  end
end
