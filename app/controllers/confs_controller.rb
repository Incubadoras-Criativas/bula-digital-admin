class ConfsController < ApplicationController

  layout "signed"

  before_action :is_signed
  before_action :set_selected

  def conf_index
    @appInfo = AppInfo.first
    @confs = @appInfo.conf.order(:nome)

    render 'confs'
  end

  def update_welcome_message
    @appInfo = AppInfo.first
    if @appInfo.update(welcome_message_params)
      msg = 'registro gravado'
    else
      msg = ''
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("form_welcome_message", partial: 'welcome_message', locals: {msg: msg})}
    end
  end

  def update_app_description
    @appInfo = AppInfo.first
    if @appInfo.update(app_description_params)
      msg = 'registro gravado'
    else
      msg = ''
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("form_app_description", partial: 'app_description', locals: {msg: msg})}
    end
  end

  def update_use_terms
    @appInfo = AppInfo.first
    if @appInfo.update(use_terms_params)
      msg = 'registro gravado'
    else
      msg = ''
    end
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("form_use_terms", partial: 'use_terms', locals: {msg: msg})}
    end
  end

  def conf_new

  end

  private

  def welcome_message_params
    params.expect(app_info: [:welcome_message])
  end

  def app_description_params
    params.expect(app_info: [:app_description])
  end

  def use_terms_params
    params.expect(app_info: [:use_terms])
  end

  def is_signed
    unless admin_signed_in?
      redirect_to home_path
    end
  end

  def set_selected
    @adm_menu = 'confs'
  end

end
