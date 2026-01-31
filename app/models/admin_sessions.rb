class AdminSessions
  include ActiveModel::Model

  attr_accessor :email, :password, :identifier
  validates_presence_of :email, :password

  def initialize(session, attributes={})
    @session = session
    @email = attributes[:email]
    @password = attributes[:password]
  end

  def authenticate!(visit)
    a = chk_login(@email)

    if a.present?
      #função Admin.authenticate definida no modelo Admin
      admin = Admin.authenticate(a.email, @password)
      if admin.present?
        store(admin)
      else
        errors.add(:base, :invalid_login)
        false
      end
    else
      errors.add(:base, :invalid_login)
      false
    end
  end

  def store(admin)
    @session[:admin_id] = admin.id
  end

  def current_admin
    if admin_signed_in?
      Admin.find(@session[:admin_id])
    else
      nil
    end
  end

  def admin_signed_in?
    @session[:admin_id].present?
  end

  def destroy
    @session[:admin_id] = nil
  end

  private

  def chk_login(admin_login)
    if admin_login.count('@') == 1
      admin = Admin.find_by(email: admin_login)
    else
      admin = Admin.find_by(nickname: admin_login)
    end

    return admin

  end
end

