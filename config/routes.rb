Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :api do
    namespace :v1 do
      resources :chatrooms, except: :show
      resources :messages, except: :show
      resources :chatroom_users
      post 'add_member', to: 'chatrooms#add_member'
      get 'active_chat', to: 'chatrooms#active_chat'
      get 'archived_chat', to: 'chatrooms#archived_chat'
    end
  end
end