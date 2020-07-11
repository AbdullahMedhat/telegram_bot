class TelegramController < ApplicationController
  def home_page
    @chats = RedisService.new.get_all_conversations
  end

  def chat_history
    chat_id = params[:chat_id]
    @messages = RedisService.new.get_chat_history(params[:chat_id])

    respond_to do |format|               
      format.js
    end 
  end


  def replay_to_conversation
    @chat_id = params[:chat_id]
    chat_content = params[:chat_content]

    @message = RedisService.new.store_admin_new_message(
      @chat_id, chat_content
    )

    TelegramService.new.replay_to_conversation(@chat_id, chat_content)

    respond_to do |format|               
      format.js
    end 
  end
end


