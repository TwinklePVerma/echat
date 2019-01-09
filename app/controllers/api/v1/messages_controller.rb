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
      @chatroom = Chatroom.create(name: "DM:#{params[:sender]}:#{params[:receiver]}")
      @chatroom.chatroom_users.create(user_id: params[:receiver], last_read_at: Time.now)
      @chatroom.chatroom_users.create(user_id: params[:sender], last_read_at: Time.now)
      @message = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet', status: 'new'}]
    end
    if @chatroom.scrum?
      render json: {message: @message, scrum_name: @chatroom.name}
    else
      if @peer.present?
        peer_id = @peer.user_id
      else
        peer_id = params[:receiver]
      end
      render json: {message: @message, peer_id: peer_id}
    end
    
  end

  def update
    @message = {status: "error", message: "no data"}
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
    render json: {status: 'success', data: [message_id: @message.id, user_id: @message.user_id]}
  end

  protected
    
  def message_params
    params.require(:message).permit(:body)
  end

  def find_chatroom
    @chatroom = Chatroom.find_by(id: params[:receiver])
    @peer = ''
    if params[:type] == 'peer'
      @peer = @chatroom.chatroom_users.find_by('user_id != ?', params[:sender])
    end
  end

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