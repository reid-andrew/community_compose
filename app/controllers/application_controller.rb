class ApplicationController < ActionController::Base
  helper_method :current_user,
                :user_permitted?

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def user_permitted?
    current_user && current_user.id == params[:id].to_i
  end
end
