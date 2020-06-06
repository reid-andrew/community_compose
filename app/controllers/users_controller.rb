class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new(flat_id: params[:flat_id])
  end

  def create
    user = User.create(user_params)
    user.id ? success(user) : failure(user)
  end

  private

  def user_params
    {
      email: params[:user][:email],
      zip: params[:user][:zip],
      flat_id: params[:flat_id],
      username: FlatService.get_user(session[:flat_key])[:username],
      about: params[:user][:about],
      interests: params[:user][:interests],
      instruments: params[:user][:instruments]
    }
  end

  def success(user)
    flash[:notice] = "Welcome #{user_params[:username]} Registration Successful"
    session[:user_id] = user.id
    redirect_to users_dashboard_index_path
  end

  def failure(user)
    flash[:error] = user.errors.full_messages.to_sentence
    @user = User.new(flat_id: params[:flat_id])
    render :new
  end
end
