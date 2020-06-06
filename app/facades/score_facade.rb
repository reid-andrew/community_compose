class ScoreFacade
  attr_reader :all_scores

  def initialize(session_key)
    @all_scores = Score.create(session_key)
  end
end
