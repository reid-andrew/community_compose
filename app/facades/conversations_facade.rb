class ConversationsFacade
  attr_reader :conversations, :recipients

  def initialize(current_user)
    @conversations = current_user.mailbox.conversations
    @recipients = User.where.not(id: current_user.id)
  end
end