require 'openai'

OpenAI.configure do |config|
  config.access_token = 'sk-ef70c5f8e570414fb4a9e764caf7a373'
  config.uri_base = "https://api.deepseek.com/v1/" # Endpoint específico do DeepSeek
end
