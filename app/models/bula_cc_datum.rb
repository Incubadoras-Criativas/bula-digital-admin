class BulaCcDatum < ApplicationRecord
  belongs_to :bula

  has_one_attached :pdf_bula
  has_rich_text :resumo
  has_rich_text :curiosidades
end
