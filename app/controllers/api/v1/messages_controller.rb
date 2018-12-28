class API::V1::MessagesController < ApplicationController
  before_action :message_params, only: :update
  before_action :find_chatroom
  after_action :update_chatroom_user, :update_chatroom
  
  def index
    if @chatroom.present?
      @message = @chatroom.messages if @chatroom.present?
      @message = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet'}] unless @message.present?
      render json: @message
    else
      @chatroom = Chatroom.create(name: "DM#{params[:sender]}:#{params[:receiver]}")
      @chatroom.chatroom_users.create(user_id: params[:receiver])
      @chatroom.chatroom_users.create(user_id: params[:sender])
      @message = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet', status: 'new'}]
      render json: @message
    end
  end

  def update
    @message = {error: 'not data'}
    @message = Message.find_by(id: params[:id])
    if @message.present?
      @message.update(body: message_params)
    end
    render json: @message
  end

  def destroy
    @message = Message.find_by(id: params[:id])
    if @message.present?
      @message.destroy
    end
    render json: {status: 'done'}
  end

  protected
    
  def message_params
    params.require(:message).permit(:body)
  end

  def find_chatroom
    if params[:sender].present? && params[:receiver].present?
      sender = Chatroom.joins(:chatroom_users).where(chatroom_users: { user_id: params[:sender] })
      receiver = Chatroom.joins(:chatroom_users).where(chatroom_users: { user_id: params[:receiver] })
      @chatroom = (sender & receiver).first
    else
      @chatroom = Chatroom.find_by(id: params[:chatroom_id])
    end
  end

  def update_chatroom
    @chatroom.update(updated_at: Time.zone.now) if @chatroom.present?
  end

  def update_chatroom_user
    if @chatroom.present?
      @user = @chatroom.chatroom_users.where(user_id: params[:sender])
      @user.update(updated_at: Time.zone.now)
    end
  end
end