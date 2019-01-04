# frozen_string_literal: true

class API::V1::ChatroomsController < ApplicationController
  include ApplicationHelper
  before_action :find_chatroom, only: [:destroy, :update, :add_member]

  def index
  end

  def create
    @chatroom = Chatroom.create(name: params[:name], direct_message: 1)
    @chatroom.chatroom_users.create(user_id: params[:user])
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

  def destroy
    @chatroom.destroy
    render json: {status: 'done'}
  end

  def add_member
    params[:member].each do |user|
      @chatroom.chatroom_users.create(user_id: user)
    end if params[:member].present?
    render json: {receiver: @chatroom.id, type: @chatroom.direct_message}
  end

  def active_chat
    find_chat('chatroom.active?')
  end

  def archived_chat
    find_chat('chatroom.archived?')
  end

  private

  def find_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  def find_chat(condition)
    chatroom_user = ChatroomUser.where(user_id: params[:user_id])
    @response_array = []
    chatroom_user.each do |user|
      chatroom = user.chatroom
      if eval(condition)
        count = unread_message_count(chatroom, user)
        if chatroom.peer?
          opposed_user = chatroom.chatroom_users - [user]
          response_hash = {id: opposed_user.first.user_id, chatroom: opposed_user.first.chatroom_id, unread_message: count}
        elsif chatroom.scrum?
          response_hash = {id: user.chatroom.id, chatroom: user.chatroom.name, unread_message: count}
        end              
        @response_array << response_hash
      end
    end
    render json: @response_array
  end

end