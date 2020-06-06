class DashboardFacade
  attr_reader :user_info, :scores

  def initialize(session_key)
    @user_info = FlatService.get_user(session_key)
    @scores = Score.create(session_key)
  end
end
