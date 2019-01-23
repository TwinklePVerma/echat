# frozen_string_literal: true

class API::V1::MessagesController < ApplicationController
  before_action :find_chatroom, except: [ :destroy, :update ]
  after_action :update_chatroom_user, :update_chatroom
  
  swagger_controller :messages, 'Message'

  swagger_api :index do
    summary 'Return messages'
    notes 'Notes...'
    param :query, :receiver, :integer, :required, "Receiver Id"
    param :query, :type, :integer, :optional, "Chatroom type"
    param :query, :sender, :integer, :required, "Sender Id"
    response :ok, "success"
    response :error, "problem in creating chatroom"
  end

  def index
    authenticate!
    if @chatroom.present?
      @message = @chatroom.messages
      @message = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet'}] unless @message.present?
      render json: {data: {message: @message, scrum_name: @chatroom.name}},
              status: :ok
    end
  end

  swagger_api :update do
    summary 'Update message text'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Message Id"
    param :query, :message, :string, :required, "Message text"
    response :ok, "success"
    response :error, "problem in creating chatroom"
  end

  def update
    authenticate!
    @message = {status: "error", message: "no data"}
    status = :error
    @message = Message.find_by(id: params[:id])
    if @message.present?
      @message.update(data: params[:message])
      status = :ok
    end
    render json: {data: @message},
            status: status
  end


  swagger_api :destroy do
    summary 'delete message'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Message Id"
    response :ok, "success"
    response :error, "problem in creating chatroom"
  end

  def destroy
    authenticate!
    @message = Message.find_by(id: params[:id])
    if @message.present?
      @message.destroy
      render json: {data: @message},
              status: :ok
    else
      render json: {status: :error}
    end
  end

  protected

  def find_chatroom
    @chatroom = Chatroom.find_by(id: params[:receiver])
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