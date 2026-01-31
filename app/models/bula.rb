class Bula < ApplicationRecord
  belongs_to :bula_grupo

  has_many :bula_concentracao_composical

  has_and_belongs_to_many :bula_indicacao

  validates_presence_of :bula_grupo_id, :denominacao

  has_many_attached :pdf_bula

  validates :pdf_bula, content_type: :pdf


  has_many :bula_cc_datum

end
