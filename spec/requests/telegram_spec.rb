require 'rails_helper'

RSpec.describe 'Telegram', type: :request do
  before(:each) do
    @redis = MockRedis.new
    @message = prepare_telegram_data
    @chat_id = @message[:chat][:id]
    @redis.rpush(@chat_id, @message.to_json)

  end

  describe 'GET /' do
    context 'Get all data stored in redis and render the views' do
      it 'should render home_page js' do
        get '/'
        read_stored_data = @redis.lrange(@chat_id, 0, -1)
        expect(read_stored_data).to be_a Array
        expect(response).to render_template(:home_page)
      end
    end
  end

  describe 'GET telegram/get_chat_history' do
    context 'Get conversation history stored in redis and render in js format' do
      it 'should render chat_history js' do
        get '/telegram/get_chat_history', params: { chat_id: @chat_id }, xhr: true 
        read_stored_data = @redis.lrange(@chat_id, 0, -1)
        read_stored_data.map! { |chat| JSON.parse(chat) }
        expect(read_stored_data).to be_a Array
        expect(read_stored_data.first['chat']['id']).to eq(@chat_id)        
        expect(response).to render_template(:chat_history) 
      end
    end
  end

  describe 'GET telegram/replay_to_conversation' do
    context 'send a replay to conversation and render in js format' do
      it 'should render replay_to_conversation js' do
        post '/telegram/replay_to_conversation',
             params: { chat_id: @chat_id, message: 'new admin message' },
             xhr: true 

        expect(response).to render_template(:replay_to_conversation) 
      end
    end
  end

  def prepare_telegram_data
    {
      update_id: 74781949,
      message:{
        message_id: 326,
        from: {
          id: 1231353648,
          is_bot: false,
          first_name: 'Abdullah Medhat',
          language_code: 'en'
        }
      },
      chat: {
        id: 1231353648, 
        first_name: 'Abdullah Medhat',
        type: 'private'
      },
      date: 1594402572,
      text: 'New message from a user in a conversation'
    }
  end

end
