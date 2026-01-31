class User < ApplicationRecord

  VALID_NOME = /\A([a-zA-Zà-úÀ-Ú]|-|'|.| |)+\z/
  VALID_EMAIL = /\A([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})\Z/i

  has_many :uid

  validates_presence_of :nome, :nickname
  validates_length_of :nome, within: 4..128, allow_blank: false
  validates_length_of :email, within: 5..128, allow_blank: true
  validates_format_of :nome, with: VALID_NOME
  validates_format_of :email, with: VALID_EMAIL, allow_blank: true

  has_secure_password

  has_one_attached :foto
  has_rich_text :bio

end
