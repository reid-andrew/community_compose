class Users::MessagesController < ApplicationController
  before_action :set_conversation

  def create
    receipt = current_user.reply_to_conversation(@conversation, params[:body])
    flash[:notice] = 'Message Sent!'
    redirect_to users_conversation_path(receipt.conversation)
  end

  def destroy
    receipt = @conversation.receipts.find(params[:id])
    receipt.update(deleted: true)
    flash[:notice] = 'Message Deleted!'
    redirect_to users_conversation_path(receipt.conversation)
  end

  private
  
  def set_conversation
    @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
  end
end