class BulaAnexo < ApplicationRecord
  belongs_to :bula_concentracao_composical

  has_rich_text :bula #bula em texto
  has_rich_text :bula_simplificada #texto da bula simplificada
  has_rich_text :bula_infos #informações e/ou curiosidades

  has_one_attached :bula_pdf #pdf original da bula
  has_many_attached :images #imagens relacionadas ao produto
end
