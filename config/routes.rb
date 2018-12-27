Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :api do
    namespace :v1 do
      resources :chatrooms, except: :show
      resources :messages, except: :show
      resources :chatroom_users
    end
  end
end