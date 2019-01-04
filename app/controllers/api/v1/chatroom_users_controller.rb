# frozen_string_literal: true

class API::V1::ChatroomUsersController < ApplicationController
  include ApplicationHelper

  def index
    chatroom_user = ChatroomUser.where(user_id: params[:user_id])
    @response_array = []
    chatroom_user.each do |chatroom_user|
      chatroom = chatroom_user.chatroom
      count = unread_message_count(chatroom, chatroom_user)
      chatroom_status = chatroom_user.chatroom.status
      opposed_user = chatroom_user.chatroom.chatroom_users.where("chatroom_users.user_id != ?", params[:user_id])
      response_hash = {chatroom: opposed_user.first.chatroom_id, user: opposed_user.first.user_id, unread_message: count, chatroom_status: chatroom_status}
      @response_array << response_hash
    end
    render json: @response_array
  end
end
