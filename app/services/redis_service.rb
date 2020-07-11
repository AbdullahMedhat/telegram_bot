class RedisService
  def initialize
      @redis = Redis.current
    end

    def get_all_conversations
      chats = []
      chat_ids = @redis.keys

      chat_ids.each do |chat|
        unparsed_data = @redis.lrange(chat, 0, -1)
        unparsed_data.map! { |chat| JSON.parse(chat) }
        chats << { chat.to_s => unparsed_data }
      end
      chats.reverse!      
    end


    def get_chat_history(chat_id)
      @messages = Redis.current.lrange(chat_id, 0, -1)
      @messages.map! { |chat| JSON.parse(chat) }
    end

    def store_admin_new_message(chat_id, message_content)
      message = {
        text: message_content,
        is_admin: true
      }

      @redis.rpush(chat_id, message.to_json)
      message
    end


end
