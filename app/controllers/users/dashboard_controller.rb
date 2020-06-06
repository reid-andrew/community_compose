class Users::DashboardController < ApplicationController
  def index
    @flat_user = DashboardFacade.new(session[:flat_key])
  end
end
