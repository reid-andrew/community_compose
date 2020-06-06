class RequestsController < ApplicationController
  def create
    Request.create(score: request_params[:score_id],
                   username: request_params[:username])
    flash[:notice] = 'Request to collaborate submitted'
    redirect_to scores_path(params: { score_id: request_params[:score_id] })
  end

  def destroy
    outcome = request_params[:type] == 'approve' ? 'approved' : 'rejected'
    add_collaborator(request_params) if outcome == 'approved'

    Request.delete(request_params[:id].to_i)
    flash[:notice] = "Request #{outcome}!"
    redirect_to scores_path(params: { score_id: request_params[:score_id] })
  end

  private

  def request_params
    params.permit(:id, :username, :score_id, :type)
  end

  def add_collaborator(request_params)
    request = Request.find(request_params[:id])
    user = User.find_by(username: request[:username])
    Score.add_collaborator(request_params[:score_id], user[:flat_id], session[:flat_key])
  end
end
