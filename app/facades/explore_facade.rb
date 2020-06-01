class ExploreFacade
  attr_reader :scores

  def initialize(current_user)
    @users =  User.where.not(id: current_user.id)
                  .where.not(flat_id: nil)
    @scores = collect_scores
  end

  def collect_scores
    all_scores = []
    @users.each do |user|
      all_scores << Score.create(user.flat_id)
    end
    all_scores.flatten
  end
end