class BulaAnalyzer
  TEMPERATURE_CONFIG = {
    fatos_medicos: 0.1, # máxima fidelidade
    simplificacacao: 0.3, # Clareza com precisão
    curiosidades: 0.7, # #criatividade controlada
    html_conversion: 0.0 # fidelidade total
  }

  def initialize
    @deepseekService = DeepseekService.new
  end

  def analyze(pdf, bula_id)
    bula = Bula.find(bula_id)
    confirm = confirm_pdf_bula(pdf, bula)
    if confirm["match"]
      data = proccesses_pdf(pdf, bula_id)

      #grava os dados recebidos no banco de dados
      if data["processado"]
        bula = Bula.find(bula.id)
        statusPDF = StatusPdfBula.find_or_create_by(blob_id: pdf.id)
        statusPDF.update(ia_response: data)
        data["apresentacao"].each do |k|
          cc = bula.bula_concentracao_composical.find_or_create_by(concentracao_composicao: k["concentração/composição"], forma: k["forma"])
          #indicações
          k["indicações"].each do |kk|
            indicacao = Indicacao.find_or_create_by(indicacao: kk)
            cc.indicacaos << indicacao
          end
          formas = data["apresentacao"].map{|k| k["forma"]}.join(', ')
          concentracao = data["apresentacao"].map{|k| k["concentração/composição"]}.join(', ')
          labs = bula.bula_cc_datum.find_or_create_by(laboratorio: data["laboratorio"], data_publicacao: data["data_publicação"].to_date)
          labs.forma = formas
          labs.cc = concentracao
          labs.pdf_bula.attach(pdf)
          labs.resumo = data["resumo_simples"]
          labs.curiosidades = data["curiosidades"]
          labs.dosagens = data["dosagens"]
          labs.indicacoes = data["indicacoes"]
          labs.data_processamento = DateTime.now
          labs.fonte = "Burlário Eletrônico - ANVISA"
          labs.aviso_legal = "Esta aplicação não fornece aconselhamento médico. Consulte um profissional de saúde."
          labs.save
          confirm[:bula_cc_data_id] = labs.id
        end
      end
    end
    #p confirm


    # em produção return confirm
    return confirm
  end

  def proccesses_pdf(pdf, bula_id)
    bula = Bula.find(bula_id)
    #pdf_path = ActiveStorage::Blob.service.path_for(pdf.key)

    pdf_infos = convert_pdf(pdf, bula)

    p pdf_infos

    return pdf_infos
  end

  private

  def convert_pdf(pdf, bula)

    #"html_integral": "TODO o conteúdo da bula convertido para HTML limpo com temperatura 0.1",
    #4. Extraia todo o conteúdo da bula em formato html dentro do campo, html_integral
    #5.
    #  ## AVISOS DE RESPONSABILIDADE (INCLUIR NO HTML):
    #  Inclua ESTE cabeçalho no início do html_integral:

    #  <div class="disclaimer-medical">
    #    <h2>💊 Informação da Bula - Avisos Importantes</h2>
    #    <p><strong>Origem dos dados:</strong> Extraído da bula original do medicamento</p>
    #    <p><strong>Processado por:</strong> Farmácia Popular do SUS</p>
    #    <div class="alert alert-warning">
    #      <strong>⚠️ ATENÇÃO:</strong> Esta é uma transcrição da bula original.
    #      CONSULTE SEMPRE UM MÉDICO antes de usar qualquer medicamento.
    #      NÃO se automedique. Em caso de emergência, ligue 0800 722 6001.
    #    </div>
    #  </div>


    pdf_text = extract_text_from_pdf(pdf)

    prompt = <<~PROMPT
      ANÁLISE COMPLETA DE BULA DE MEDICAMENTO

      ## INSTRUÇÕES:
      Analise o texto (bula de medicamento):
      #{pdf_text}

      Retorne UM JSON com as seguintes seções:

      {
        "processado": true/false
        "apresentacao": com temperature 0.1 para máxima precisão. "Todas as dosagens, formas e indicaçoes contidas na bula em um array [] com um hash contentendo as seções:
          concentração/composição: contendo apenas a gradação do princípio ativo por exemplo: 50 mg ou 0,1 mg/ml ou 10 mg/g (1%) ou 2 mEq/ml ou 70% ou 1000 UI etc.,
          forma,
          indicações em um array"
        "laboratorio": "Nome do laboratório responsável",
        "data_publicação": "Data de publicação ou atualização da bula, se houver."
        "resumo_simples": "Resumo em linguagem simples convertido para html (temperatura 0.4) contendo: indicações, contraindicações, posologia, cuidados importantes e outras informações relevantes",
        "curiosidades": "Curiosidades e histórico sobre o medicamento (temperatura 0.7) em liguagem simples, convertido para html para fácil leitura e entendimento",
        "dosagens": "Dosagens/concentrações mencionadas",
        "indicacoes": "Indicações terapêuticas",
      }

      Regras:
      0. Em caso de erro, informe o motivo.
      1. processado = true apenas se tiver sucesso em executar todas as tarefas solicitasas, caso contrario retorne um json: {"processado": false, "motivo": "Descreva o motivo da falha."}.
      2. Apresentação: Extraia todas as concentações e/ou composições contidas no documento, contendo somente a gradação do princípio(s) ativo(s), por exemplo: 50 mg ou 0,1 mg/ml ou 10 mg/g (1%) ou 2 mEq/ml ou 70% ou 1000 UI etc.
      3. O nome completo do laboratório responsável pelo documento.

      4.
      ## NOTAS EDUCATIVAS (INCLUIR NO RESUMO):
      - Incluir: "Esta informação é um resumo educativo"
      - Destacar: "Não substitui consulta médica"
      - Incluir: "Mantenha medicamentos fora do alcance de crianças"
      5.
      ## FORMATO DO JSON:
      Retorne APENAS o JSON válido, sem markdown ou texto adicional.
      PROMPT


      p "**** PROMPT ****"
      p prompt

      #pdf_path = ActiveStorage::Blob.service.path_for(pdf.key)

      #response = @deepseekService.chat_with_attachment(
      #  prompt,
      #  pdf_path,
      #  File.basename(pdf_path),
      #  0.3
      #)

      response = @deepseekService.chat(
      [
        {role: "system", content: "Você é um farmacêutico experiente e atencioso e vai analisar a bula de um medicamento."},
        { role: "user", content: prompt}
      ],
      temperature: 0.1, #baixa temperatura para precisão
      model: "deepseek-chat"
      )

      response = response.gsub(/```json\n?|\n?```/, '') if response

      return JSON.parse(response) rescue { error: "Falha ao processar resposta" }
      #return response
  #rescue => e
  #  Rails.logger.error("Erro na conversão do documento: #{e.message}")
  end

  def confirm_pdf_bula(pdf, bula)
    pdf_text = extract_text_from_pdf(pdf)
    verification_result = verify_pdf(pdf_text, bula.denominacao)
    return verification_result
  rescue => e
    Rails.logger.error("Erro na verificação do PDF: #{e.message}")
    false
  end

  def extract_text_from_pdf(pdf)
    pdf_path = ActiveStorage::Blob.service.path_for(pdf.key)
    text = read_pdf_file(pdf_path)
    return text
  end

  def read_pdf_file(pdf_path)
    require 'pdf/reader'

    text = ""
    PDF::Reader.open(pdf_path) do |reader|
      reader.pages.each do |page|
        text << page.text
      end
    end
    return text
  rescue => e
    Rails.logger.error("Erro ao ler PDF: #{e.message}")
  end

  def verify_pdf(pdf_text, denominacao)
    prompt = <<~PROMPT
    VERIFICAÇÂO RÁPIDA DE CORRESPONDÊNCIA

    Medicamento esperado: #{denominacao}

    Texto extraído do PDF (primeiros 1000 caracteres):
    #{pdf_text[0..1000]}

    Responda apenas com JSON neste formato:

    {
      "match": true/false,
      "nome_encontrado": "nome encontrado no texto (se houver)",
      "confidence": 0.0 a 1.0,
      "reference": "sobre o que se refere o texto?"
    }

    Regras:
    1. match = true apenas se o texto claramente se refere ao medicamento esperado.
    2. Não considere variações de nomes.
    3. Não considere nome compostos com outras medicação diferentes do medicamento esperado.
    4. Se não tiver certeza, retorne match false
    5. Extraia o nome exato encontrado no texto
    6. Informe sobre o que se refere o PDF.
    PROMPT

    response = @deepseekService.chat(
      [
        {role: "system", content: "Você verifica se um texto de bula corresponde a um medicamento específico."},
        { role: "user", content: prompt}
      ],
      temperature: 0.1, #baixa temperatura para precisão
      model: "deepseek-chat"
    )

    p "****** PROMPT ******"
    p prompt

    response = response.gsub(/```json\n?|\n?```/, '')

    return {match: false, nome_encontrado: nil, confidence: 0, reference: '' } if response.nil?

    begin
      result = JSON.parse(response)
      {
        match: result["match"],
        nome_encontrado: result["nome_encontrado"],
        confidence: result["confidence"].to_f,
        reference: result["reference"]
      }
    rescue JSON::ParserError
      Rails.logger.error("Resposta da API não é JSON válido: #{response}")
      { match: false, found_name: nil, confidence: 0 }
    end

    p "******* response *****"
    p response

    p "************ result *************"
    p result
  end
end
