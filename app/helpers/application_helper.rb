module ApplicationHelper
  def error_tag(model, attribute)
    if model.errors.has_key? attribute
      model.errors[attribute].first
    end
  end

  def importa_medicamento(file_json)
    j = JSON.parse(File.read(file_json))
    grupo = j["grupo"]
    bg = BulaGrupo.find_by(sigla: grupo)
    if bg.present?
      medicamentos = j["medicamentos"]
      if medicamentos.present?
        medicamentos.each do |k|
          b = bg.bula.find_or_create_by(denominacao: k["denominacao"])
          concentracoes = k["concentracoes"]
          if concentracoes.present?
            concentracoes.each do |kk|
              bcc = b.bula_concentracao_composical.find_or_create_by(concentracao_composicao: kk["concentracao"], forma: kk["forma_farmaceutica"], atc: kk["ATC"])
            end
          end
        end
      end
    end
  end
end
