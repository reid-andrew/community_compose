class ExploreFacade
  attr_reader :scores, :distances, :users

  def initialize(current_user, session_key)
    @distances = Location.distances(current_user.zip)
    @users =  sorted(current_user)
    @scores = collect_scores(session_key)
  end

  def sorted(current_user)
    local_users(current_user).sort_by do |user|
      user.get_distance(@distances)
    end
  end

  def collect_scores(session_key)
    all_scores = []
    @users.each do |user|
      all_scores << Score.create(user.flat_id, session_key)
    end
    all_scores.flatten
  end

  private

  def local_users(current_user)
    User.where(zip: Location.distances(current_user.zip).keys)
        .where.not(id: current_user.id)
  end
end
