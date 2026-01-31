class Admin < ApplicationRecord

  VALID_NOME = /\A([a-zA-Zà-úÀ-Ú]|-|'|.| |)+\z/
  VALID_EMAIL = /\A([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of :nome, :email, :nickname
  validates_length_of :nome, within: 4..128, allow_blank: false
  validates_length_of :email, within: 5..128, allow_blank: false
  validates_format_of :nome, with: VALID_NOME
  validates_format_of :email, with: VALID_EMAIL
  enum :role, { 'Nenhum' =>  0, 'Editor' =>  1, 'Administrador' => 2 }
  validates_uniqueness_of :email, :nickname


  has_secure_password

  has_one_attached :foto
  has_rich_text :bio

  def self.authenticate(email, password)
    admin = Admin.find_by(email: email)
    if admin.present?
      admin.authenticate(password)
    end
  end
end
