Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  telegram_webhook TelegramWebhooksController
  root to: 'telegram#home_page'
  get 'telegram/get_chat_history', to: 'telegram#chat_history', as: 'chat_history'
  post 'telegram/replay_to_conversation', to: 'telegram#replay_to_conversation'
end
