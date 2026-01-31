class BulaConcentracaoComposical < ApplicationRecord
  belongs_to :bula

  has_many :bula_anexo

  validates_presence_of :concentracao_composicao, :forma

  has_many :cc_indicacaos
  has_many :indicacaos, through: :cc_indicacaos

end
