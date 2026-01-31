class Uid < ApplicationRecord
  belongs_to :user

  validates_presence_of :uid


  def self.new_user(p_uid, params)
    p "uid -> #{p_uid}"
    p "params -> #{params}"
    nome = "tmp-#{Base64.urlsafe_encode64(SecureRandom.uuid).delete('=')[0..8]}"
      t = 0
      while User.exists?(nome: nome) && t < 15
        nome = "tmp-#{Base64.urlsafe_encode64(SecureRandom.uuid).delete('=')[0..8]}"
        t += 1
      end
      u = User.create(
        nome: nome,
        email: "#{nome}@inexistente.mail",
        nickname: nome,
        password: nome,
        password_confirmation: nome
      )
      self.create(uid: p_uid, user_id: u.id, identifier: params)

      p "UID messages"
      p self.error.messages

      return u
  end
end
