class AdminsController < ApplicationController

  layout "signed"

  PERPAGE = 20

  before_action :can_access
  before_action :can_change, only: [:create, :update] #adicionar alteração de senha
  before_action :set_admin, only: %i[ show edit update destroy ]
  before_action :set_selected

  # GET /admins or /admins.json
  def index
    @admins = Admin.all

    render 'index'
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to @admin, notice: "Admin was successfully created." }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: "Admin was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy!

    respond_to do |format|
      format.html { redirect_to admins_path, notice: "Admin was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def adm_page_main
    @page = 0
    @query = ''
    @admins = lista_admins(@page, @query)
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
          turbo_stream.update('lista_admins_count', plain: str),
          turbo_stream.update('main_lista_admins', partial: 'admins_lista_container')
        ]
      end
    end
  end

  def adm_next_page

  end

  def adm_filter

  end

  def adm_create
    @admin = Admin.new(admin_params)
    respond_to do |format|
      if @admin.save
        message = 'Registro criado.'
        format.turbo_stream { redirect_to edit_admin_path(@admin.id), msg: message}
      else
        message = ''
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_admin', partial: 'new')}
      end
    end
  end

  def adm_update
    @admin = Admin.find(params[:admin_id])
    respond_to do |format|
      if @admin.update(admin_params)
        message = "Registro gravado."
        format.turbo_stream { render turbo_stream: turbo_stream.replace('edit_admin', partial: 'edit', locals: {msg: message})}
        format.html { render :edit }
      else
        message = ''
        format.turbo_stream {render turbo_stream: turbo_stream.replace('edit_admin', partial: 'edit', locals: { msg: message})}
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def adm_change_password
    @admin = Admin.find(params[:admin_id])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.append("main", partial: "shared/app_modal", locals: { display: 'block', title: 'Alterar Senha', partial: 'change_password'})}
    end
  end

  def adm_update_password
    @admin = Admin.find(params[:admin_id])
    respond_to do |format|
      if @admin.update(admin_params)
        format.turbo_stream {render turbo_stream: turbo_stream.remove('modal-window')}
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("admin-change-pass", partial: "change_password")}
      end
    end
  end

  private
    def can_access
      unless admin_signed_in?
        redirect_to root_path
      end
    end

    def can_change
      unless admin_signed_in? && current_admin.role == 'Administrador'
        redirect_to admins_path
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.expect(admin: [ :nome, :email, :nickname, :password, :password_confirmation, :role, :foto, :bio ])
    end

    def set_selected
      @adm_menu = 'admins'
    end

    def lista_admins(page, query)
      if query == ''
        lista = Admin.order(:nome).offset(page * PERPAGE).limit(PERPAGE)
        @count = Admin.count
      else
        lista = Admin.where("nome ILIKE '%#{query}%' OR email ILEKE '%#{query}%' OR nickname ILIKE '%#{query}%'").order(:nome).offset(page * PERPAGE).limit(PERPAGE)
        @count = Admin.where("nome ILIKE '%#{query}%' OR email ILEKE '%#{query}%' OR nickname ILIKE '%#{query}%'")
      end

      @more = (@count < page * PERPAGE ? 1 : 0)

      return lista
    end
end
