class HomeController < ApplicationController
  layout 'unsigned'

  def index
    render "index"
  end

  def request_login
    render 'login'
  end

end
