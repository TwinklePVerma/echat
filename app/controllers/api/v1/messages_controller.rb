# frozen_string_literal: true

class API::V1::MessagesController < ApplicationController
  before_action :message_params, only: :update
  before_action :find_chatroom, except: :destroy
  after_action :update_chatroom_user, :update_chatroom
  
  def index
    if @chatroom.present?
      @message = @chatroom.messages
      @message = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet'}] unless @message.present?
    else
      @chatroom = Chatroom.create(name: "DM#{params[:sender]}:#{params[:receiver]}")
      @chatroom.chatroom_users.create(user_id: params[:receiver])
      @chatroom.chatroom_users.create(user_id: params[:sender])
      @message = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet', status: 'new'}]
    end
    if @chatroom.scrum?
      render json: {message: @message, scrum_name: @chatroom.name}
    else
      render json: {message: @message}
    end
    
  end

  def update
    @message = {error: 'no data'}
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
    render json: {status: 'done', message_id: @message.id, user_id: @message.user_id}
  end

  protected
    
  def message_params
    params.require(:message).permit(:body)
  end

  def find_chatroom
    if params[:type] == 'peer'
      sender = Chatroom.joins(:chatroom_users).where(chatroom_users: { user_id: params[:sender] })
      receiver = Chatroom.joins(:chatroom_users).where(chatroom_users: { user_id: params[:receiver] })
      @chatroom = (sender & receiver).first
    elsif params[:type] == 'scrum'
      @chatroom = Chatroom.find_by(id: params[:receiver])
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