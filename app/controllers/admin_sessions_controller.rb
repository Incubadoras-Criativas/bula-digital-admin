class AdminSessionsController < ApplicationController

  layout "unsigned"

  def new
    @admin_session = AdminSessions.new(session)
  end

  def create
    @admin_session = AdminSessions.new(session, params[:admin_sessions])
    if @admin_session.authenticate!(current_visit)
      redirect_to admins_path
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("frm-login", partial: 'home/login', locals: { message: 'Login e/ou senha inválido!'})}
      end
    end
  end

  def destroy
    admin_session.destroy;
    redirect_to root_path, notice: 'logout'
  end

end
