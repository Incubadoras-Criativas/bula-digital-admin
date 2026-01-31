class CreateStatusPdfBulas < ActiveRecord::Migration[8.1]
  def change
    create_table :status_pdf_bulas do |t|
      t.bigint :blob_id
      t.string :status

      t.timestamps

      t.index :blob_id, unique: true
    end
  end
end
