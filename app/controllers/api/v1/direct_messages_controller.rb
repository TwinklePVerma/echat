class API::V1::DirectMessagesController < ApplicationController
  after_action :update_chatroom_user, :update_chatroom

  def index
    authenticate!
    users = [params[:sender], params[:receiver]]
    @chatroom = Chatroom.direct_message_for_users(users)
    @messages = @chatroom.messages ? @chatroom.messages : [{ chatroom_id: @chatroom.id, body: 'Not chatted yet'}]
    render json: {data: {message: @messages, peer_id: params[:receiver]}}, 
            status: :ok      
  end

  protected

  def update_chatroom
    @chatroom.update(updated_at: Time.zone.now) if @chatroom.present?
  end

  def update_chatroom_user
    if @chatroom.present?
      @user = @chatroom.chatroom_users.where(user_id: params[:sender])
      @user.update(last_read_at: Time.zone.now)
    end
  end
end