class AddIaReturnToStatusPdfBula < ActiveRecord::Migration[8.1]
  def change
    add_column :status_pdf_bulas, :ia_response, :jsonb
  end
end
