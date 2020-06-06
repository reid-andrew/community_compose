class Users::ConversationsController < ApplicationController
  def index
    @conversations_facade = ConversationsFacade.new(current_user)
  end
  
  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
  end

  def new
    @recipients = User.where.not(id: current_user.id)
  end

  def create
    recipient = User.find(params[:user_id])
    receipt = current_user.send_message(recipient, params[:body], params[:subject])
    if receipt.save
      flash[:notice] = 'Message sent!'
      redirect_to users_conversation_path(receipt.conversation)
    end
  end

  def destroy
    conversation = current_user.mailbox.conversations.find(params[:id])
    conversation.move_to_trash(current_user)
    flash[:notice] = 'Conversation Removed!'
    redirect_to users_conversations_path
  end
end
