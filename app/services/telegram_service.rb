class TelegramService
  def initialize; end

  def replay_to_conversation(chat_id, message_content)
    Telegram.bot.send_message(
      chat_id: chat_id, text: message_content
    )
  end
end
