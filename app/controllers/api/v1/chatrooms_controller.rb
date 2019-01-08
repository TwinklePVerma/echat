# frozen_string_literal: true

class API::V1::ChatroomsController < ApplicationController
  before_action :find_chatroom, only: [:destroy, :update, :add_member, :remove_member, :show]

  def create
    @chatroom = Chatroom.create(name: params[:name], direct_message: 1)
    params[:member].each do |member_id|
      @chatroom.chatroom_users.create(user_id: member_id)
    end
    render json: @chatroom
  end

  def update
    if @chatroom.active?
      @chatroom.archived!
    else
      @chatroom.active!
    end
    render json: {status: @chatroom.status}
  end

  def show
    chatroom_users = @chatroom.chatroom_users
    chatroom_users_data = []
    chatroom_users_data_temp = {}
    chatroom_users.each do |user|
      chatroom_users_data << {'member_user': user.user_id}
    end
    render json: chatroom_users_data
  end

  def destroy
    @chatroom.destroy
    render json: {status: 'done'}
  end

  def add_member
    params[:member].each do |user|
      @chatroom.chatroom_users.create(user_id: user)
    end
    render json: {receiver: @chatroom.id, type: @chatroom.direct_message}
  end

  def remove_member
    chatroom_user = @chatroom.chatroom_users.find_by(user_id: params[:user_id])
    if chatroom_user.present?
      chatroom_user.destroy
    end
    render json: {receiver: @chatroom.id, type: @chatroom.direct_message}
  end

  def active_chat
    @response = FindChat.new(user_id: params[:user_id]).active_chat
    render json: @response
  end

  def archived_chat
    @response = FindChat.new(user_id: params[:user_id]).archived_chat
    render json: @response
  end

  private

  def find_chatroom
    @chatroom = Chatroom.find_by(id: params[:id])
  end

end