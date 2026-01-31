class DeepseekService
  def initialize
    @client = OpenAI::Client.new(
      request_timeout: 120, # 2 minutos
      connect_timeout: 30,
      write_timeout: 30,
      read_timeout: 120
    )
  end

  def chat(messages, model: "deepseek-chat", temperature: 0.7)
    response = @client.chat(
      parameters: {
        model: model,
        messages: messages,
        temperature: temperature,
        max_tokens: 4000
      }
    )

    response.dig("choices", 0, "message", "content")
  #rescue => e
  #  Rails.logger.error("DeepSeek API Error: #{e.message}")
  #  nil
  end

  # Método específico para código
  def code_completion(prompt, model: "deepseek-coder")
    messages = [
      { role: "user", content: prompt }
    ]

    chat(messages, model: model, temperature: 0.1)
  end

  def chat_with_attachment(prompt, file_path, filename, model="deepseek-chat", temperature=0.7)

    p "***** chat_att ****"
    p prompt
    p file_path
    p filename
    p "*********************"



    # Lê e converte para Base64
    file_content = File.read(file_path, mode: 'rb')
    base64_file = Base64.strict_encode64(file_content)

    # FORMATAÇÃO CORRETA para a API do DeepSeek
    response = @client.chat(
      parameters: {
        model: model,
        messages: [
          {
            role: "user",
            content: [
              {
                type: "text",
                text: prompt
              }
            ]
          }
        ],
        # ADICIONA o arquivo em parâmetro separado (se suportado)
        # OU usa o formato alternativo:
        attachments: [
          {
            file: base64_file,
            file_name: filename
          }
        ],
        temperature: temperature,
        max_tokens: 4000,
        response_format: { type: "json_object" } # CRÍTICO para JSON
      }
    )

    response.dig("choices", 0, "message", "content")
  #rescue => e
  #  Rails.logger.error("DeepSeek API with attachment error: #{e.message}")
    # Log detalhado para debugging
   # Rails.logger.error("File size: #{File.size(file_path)} bytes") if File.exist?(file_path)
   # nil
  end

end
