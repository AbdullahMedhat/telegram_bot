class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include AbstractController::Rendering

  def start!(*)

    respond_with :message, text: t('.hi')
  end

  def message(message)
    @redis = Redis.current

    chat_id = message['chat']['id']    
    @redis.rpush(chat_id, message.to_json)
  end
end
