class SessionsController < ApplicationController
  def create
    body = LoginService.log_user_in(params[:code])
    session[:flat_key] = body[:access_token]
    user = User.find_by(flat_id: body[:user])
    return redirect_to new_user_path(params: { flat_id: body[:user] }) if user.nil?
    session[:user_id] = user.id
    redirect_to users_dashboard_index_path
  end

  def destroy
    session.clear
    flash[:notice] = 'Successfully logged out'
    redirect_to root_path
  end
end
