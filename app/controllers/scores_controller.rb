class ScoresController < ApplicationController
  def index
    @score = Score.show(params[:score_id], session[:flat_key])
    @score_bank = ScoreFacade.new(session[:flat_key])
  end

  def new; end

  def create
    score = Score.new_score(params[:title], params[:clef], session[:flat_key])
    redirect_to "/scores?score_id=#{score[:id]}"
  end

  def update
    respond_to do |format|
      format.js { flash.now[:notice] = 'Your changes were submitted!'}
    end
  end

  def destroy
    Score.delete(params[:id], session[:flat_key])
    redirect_to users_dashboard_index_path
  end
end
