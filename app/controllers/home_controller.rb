class HomeController < ApplicationController
  def index
    if authenticated?
      redirect_to gastos_path
    else
      redirect_to login_path
    end
  end
end
