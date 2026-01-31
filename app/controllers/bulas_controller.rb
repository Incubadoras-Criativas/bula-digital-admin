class BulasController < ApplicationController

  layout "signed" #define o layout para as respostas do controllador, no caso, o layout para usuários autenticados no sistema

  PERPAGE = 20 #constante que define quantos registos serão exibidos a cada nova página

  before_action :is_signed #verifica se o usuário atual está autenticado antes de responder a qualquer requisição
  before_action :set_selected #marcação para destacar no menu lateral que estamos interagindo com o modelo bula.

  def bulas_index #página inicial com a listagem das bulas cadastradas
    @bulas = Bula.all
    render 'bulas'
  end

  def bula_filter #localização/filtragem dos registros cadastrados
    @page = 0
    @query = find_params

    p "%%%% @query %%%"
    p @query
    p @query.to_h

    @bulas = lista_bulas(@page, @query.to_h)

    case @count
    when 0
      str = 'Nenhum registro na consulta.'
    when 1
      str = "#{@count} registro na consulta."
    else
      str = "#{@count} registros na consulta"
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('lista_bulas_count', plain: str),
          turbo_stream.update('main_lista_bulas', partial: 'bulas_lista_container')
        ]
      end
    end

  end

  def bula_page_main #carrega a primeira página da listagem

    @page = 0
    @query = ''
    @bulas = lista_bulas(@page, @query)

    case @count
    when 0
      str = 'Nenhum registro na consulta.'
    when 1
      str = "#{@count} registro na consulta."
    else
      str = "#{@count} registros na consulta"
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('lista_bulas_count', plain: str),
          turbo_stream.update('main_lista_bulas', partial: 'bulas_lista_container')
        ]
      end
    end
  end

  def bula_next_page #carrega as próximas páginas da listagem
    @page = params[:page].to_i
    @query = JSON.parse(params[:query])

    @bulas = lista_bulas(@page, @query)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append('bulas_list', partial: 'lista_bulas_items'),
          turbo_stream.update('more_items', partial: 'bulas_pagination')
        ]
      end
    end
  end

  def bula_new #exibe o formulário para criação de um novo item
    @bula = Bula.new
  end

  def bula_create #cria um novo ítem bula
    @bula = Bula.new(bula_params)

    respond_to do |format|
      if @bula.save
        format.turbo_stream { redirect_to bula_show_path(@bula.id)}
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace('new_bula', partial: 'bula_new')}
      end
    end
  end

  def bula_show #exibe o dados da bula selecionada
    @bula = Bula.find(params[:bula_id])
    @bulaCC = @bula.bula_concentracao_composical.order(:concentracao_composicao)
    @bulaData = @bula.bula_cc_datum.order(data_publicacao: :desc)
    @bulaVariacao = @bula.bula_concentracao_composical.new
    #links para anterior e próximo
    bulas = Bula.order(:bula_grupo_id, :denominacao).pluck(:id)
    bulaIndex = bulas.index(@bula.id)
    @bulaNext = bulas[bulaIndex + 1] rescue nil
    @bulaPrev = bulas[bulaIndex - 1] rescue nil

  end

  def bula_update #Grava alterações no registro cadastrado
    @bula = Bula.find(params[:bula_id])

    if @bula.update(bula_params)
      msg = 'Registro gravado'
    else
      msg = ''
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("edit_bula", partial: 'bula_edit', locals: {msg: msg} )}
    end
  end

  def bulacc_create #cria uma nova variação para o medicamento atual
    @bula = Bula.find(params[:bula_id])
    @bulaVariacao = @bula.bula_concentracao_composical.new(bulacc_params)

    respond_to do |format|
      if @bulaVariacao.save
        msg = 'Registro criado'
        format.turbo_stream do
          id = @bulaVariacao.id
          selected = "edit-#{id}"
          @bulaCC = @bula.bula_concentracao_composical.order(:concentracao_composicao)
          @bulaVariacao = @bula.bula_concentracao_composical.new
          render turbo_stream: [
            turbo_stream.update("bulaCC-menu", partial: "tabs_title", locals: { selected: selected}),
            turbo_stream.update("bulaCC-data", partial: "tabs_data", locals: {selected: selected, msg[id] => msg})
          ]
        end
      else
        format.turbo_stream { render turbo_stream: turbo_stream.turbo_stream.replace("new_bula_variation", partial: 'bula_variation_new', locals: { selected: 'new', msg: ''} ) }
      end
    end
  end

  def bulacc_update
    @bula = Bula.find(params[:bula_id])
    @bulaVariacao = @bula.bula_concentracao_composical.find(params[:variation_id])

    if @bulaVariacao.update(bulacc_params)
      msg = 'Registro Gravado'
    else
      msg = ''
    end

    respond_to do |format|
      format.turbo_stream  do
        render turbo_stream: [
          turbo_stream.replace("edit_bula_variation_#{@bulaVariacao.id}", partial: 'bula_variation_edit', locals: {msg[@bulaVariacao.id] => msg, bulaCC: @bulaVariacao}),
          turbo_stream.update("tabTitle-#{@bulaVariacao.id}", @bulaVariacao.concentracao_composicao)
        ]
      end
    end
  end

  def upload_bula
    @bula = Bula.find(params[:bula_id])
    respond_to do |format|
      if @bula.pdf_bula.attach(params[:bula][:pdf_bula])
        msg = 'PDF enviado.'
        format.turbo_stream { render turbo_stream: turbo_stream.replace("anexos-bula-#{@bula.id}", partial: "pdf_bula", locals: {msg: msg})}
      else
        msg = ''
        format.turbo_stream { render turbo_stream: turbo_stream.replace("pdf_bula_#{@bula.id}", partial: "pdf_bula", locals: {msg: msg})}
      end
    end
  end

  def processa_pdf
    @bula = Bula.find(params[:bula_id])
    @pdf = ActiveStorage::Blob.find(params[:blob_id])

    if @bula.present? && @pdf.present?
      analyzer = BulaAnalyzer.new
      pdf_data = analyzer.analyze(@pdf, @bula.id)
      msg = {text: '', result: false}
      if pdf_data.nil?
        msg[:text] = 'Não foi possivel processar o arquivo.'
        msg[:result] = false
      elsif pdf_data["match"] == false
        msg[:text] = "O arquivo não corresponde à bula \n#{pdf_data['reference']}"
        msg[:result] = false
      elsif pdf_data["match"] == true
        msg[:text] = "#{pdf_data["match"]} | #{pdf_data['reference']} - Confiança: #{pdf_data['confidence']}"
        msg[:result] = true
        pdf_infos = analyzer.proccesses_pdf(@pdf, @bula.id)
      end
      statusPDF = StatusPdfBula.find_or_create_by(blob_id: @pdf.id)
      statusPDF.update(status: msg[:text], match: pdf_data["match"])
      respond_to do |format|
        if msg[:result]
          @bulaData = @bula.bula_cc_datum.order(data_publicacao: :desc)
          format.turbo_stream do
            render turbo_stream: [
              #atlualiza apenas a linha da listagem de arquivos
              turbo_stream.update("pdf-status-#{@pdf.id}", statusPDF.status),
              #atualiza todas as bulas e seleciona a bula recém adicionada
              turbo_stream.update("bula-cc-data", partial: "bula_cc_data", locals: { tab_selected: "show-data-#{pdf_data[:bula_cc_data_id]}"})
            ]
          end
        else
         #atualiza a linha da lista e a tab com o medicamento/dosagem e laboratório.
         format.turbo_stream { render turbo_stream: turbo_stream.update("pdf-status-#{@pdf.id}", statusPDF.status)}
        end
      end
    else
      head :ok
    end
  end

  def remove_pdf

  end

  def update_resumo
    bula = Bula.find(params[:bula_id])
    bula_data = bula.bula_cc_datum.find(params[:bula_cc_datum_id])
    if bula_data.update(resumo_params)
      msg = 'Resumo gravado.'
    else
      msg = ''
    end

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("resumo-#{bula_data.id}", partial: "edit_resumo", locals: {bula_data: bula_data, msg: msg})
      }
    end
  end

  def update_curiosidade
    bula = Bula.find(params[:bula_id])
    bula_data = bula.bula_cc_datum.find(params[:bula_cc_datum_id])
    if bula_data.update(curiosidade_params)
      msg = 'Curiosidade gravada.'
    else
      msg = ''
    end

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("curiosidade-#{bula_data.id}", partial: "edit_curiosidade", locals: {bula_data: bula_data, msg: msg})
      }
    end
  end

  private

  def find_params
    params.require(:query).permit(:grupo, :nome)
  end

  def curiosidade_params
    params.expect(bula_cc_datum: [:curiosidades])
  end

  def resumo_params
    params.expect(bula_cc_datum: [:resumo])
  end

  def bulacc_params
    params.expect(bula_concentracao_composical: [:concentracao_composicao, :forma, :atc])
  end

  def bula_params
    params.expect(bula: [:bula_grupo_id, :denominacao])
  end

  def lista_bulas(page, query)

    p "***** query *****"
    p query


    if query == ''
      p "Query == ''"
      lista = Bula.order(:denominacao).offset(page * PERPAGE).limit(PERPAGE)
      @count = Bula.count
    else
      s = query["nome"]
      g = query["grupo"]
      p "query = s > #{s} g > #{g}"
      if g.present?
        lista = Bula.where("bula_grupo_id = ?", g).where("denominacao ILIKE '%#{s}%'").order(:denominacao).offset(page * PERPAGE).limit(PERPAGE)
        @count = Bula.where("bula_grupo_id = ?", g).where("denominacao ILIKE '%#{s}%'").order(:denominacao).count
      else
        p "query s > #{s}"
        lista = Bula.where("denominacao ILIKE '%#{s}%'").order(:denominacao).offset(page * PERPAGE).limit(PERPAGE)
        @count = Bula.where("denominacao ILIKE '%#{s}%'").count
      end
    end

    @more = (@count > page * PERPAGE ? 1 : 0)

    return lista
  end

  def is_signed #verifica se o usuário está autenticado
    unless admin_signed_in?
      redirect_to home_path
    end
  end

  def set_selected #define o item destacdo no menu kateral
    @adm_menu = 'bula'
  end






end
