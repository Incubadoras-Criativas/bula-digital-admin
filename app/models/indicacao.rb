class Indicacao < ApplicationRecord
  has_many :cc_indicacaos
  has_many :bula_concentracao_composical, through: :cc_indicacaos
end
