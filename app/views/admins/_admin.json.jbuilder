json.extract! admin, :id, :nome, :email, :nickname, :role, :created_at, :updated_at
json.url admin_url(admin, format: :json)
