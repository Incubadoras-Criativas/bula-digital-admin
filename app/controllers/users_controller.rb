class UsersController < ApplicationController

  layout "signed"

  PERPAGE = 20

  before_action :is_admin, except: [:users]
  before_action :is_signed, only: [:users]
  before_action :set_selected

  def users
    @users = User.all
    render 'users'
  end

  def user_show
    @user = User.find(params[:user_id])

    render 'user'
  end

  def user_filter
    @page = 0
    @query = params[:query]

    @users = lista_users(@page, @query)

    case @count
    when 0
      str = 'Nenhum usuário na consulta.'
    when 1
      str = "#{@count} usuário na consulta."
    else
      str = "#{@count} usuários na consulta"
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('lista_users_count', plain: str),
          turbo_stream.update('main_lista_users', partial: 'users_lista_container')
        ]
      end
    end
  end

  def user_page_main
    @page = 0
    @query = ''
    @users = lista_users(@page, @query)

    case @count
    when 0
      str = 'Nenhum usuário na consulta.'
    when 1
      str = "#{@count} usuário na consulta."
    else
      str = "#{@count} usuários na consulta"
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('lista_users_count', plain: str),
          turbo_stream.update('main_lista_users', partial: 'users_lista_container')
        ]
      end
    end
  end

  def user_next_page
    @page = params[:page].to_i
    @query = JSON.parse(params[:query])

    @users = lista_users(@page, @query)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('users_list', partial: 'lista_users_items'),
          turbo_stream.update('more_items', partial: 'users_pagination')
        ]
      end
    end
  end

  private

  def is_admin
    unless admin_signed_in? && current_admin.role == 'Administrador'
      redirect_to users_path
    end
  end

  def is_signed
    unless admin_signed_in?
      redirect_to home_path
    end
  end

  def set_selected
    @adm_menu = 'users'
  end

  def lista_users(page, query)
    if query == ''
      lista = User.order(:nome).offset(page * PERPAGE).limit(PERPAGE)
      @count = User.count
    else
      s = query["nome"]
      lista = User.where("nome ILIKE '%#{s}%' OR email ILIKE '%#{s}%' OR nickname ILIKE '%#{s}%'").order(:nome).offset(page * PERPAGE).limit(PERPAGE)
      @count = User.where("nome ILIKE '%#{s}%' OR email ILIKE '%#{s}%' OR nickname ILIKE '%#{s}%'").count
    end

    @more = (@count > page * PERPAGE ? 1 : 0)

    return lista
  end

end
