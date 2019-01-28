Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :projects
  get 'login', to: 'admin_sessions#login'
  resources :admin_sessions, only: :create
  get 'logout', to: 'admin_sessions#logout'
  namespace :api do
    namespace :v1 do
      resources :chatrooms
      resources :messages, except: :show
      post '/chatrooms/:id/add_member', to: 'chatrooms#add_member'
      delete '/chatrooms/:id/remove_member/:user_id', to: 'chatrooms#remove_member'
      get 'active_chat', to: 'chatrooms#active_chat'
      get 'archived_chat', to: 'chatrooms#archived_chat'
      put '/chatrooms/:id/archive', to: 'chatrooms#archive'
      put '/chatrooms/:id/active', to: 'chatrooms#active'
      put 'make_admin', to: 'chatrooms#make_admin'
      put 'dismiss_admin', to: 'chatrooms#dismiss_admin'
      resources :direct_messages, only: :index
    end
  end
end