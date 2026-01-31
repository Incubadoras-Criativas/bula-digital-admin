class CcIndicacao < ApplicationRecord
  belongs_to :bula_concentracao_composical
  belongs_to :indicacao
end
