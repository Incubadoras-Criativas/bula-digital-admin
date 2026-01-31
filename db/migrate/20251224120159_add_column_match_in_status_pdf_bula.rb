class AddColumnMatchInStatusPdfBula < ActiveRecord::Migration[8.1]
  def change
    add_column :status_pdf_bulas, :match, :boolean, default: false
  end
end
