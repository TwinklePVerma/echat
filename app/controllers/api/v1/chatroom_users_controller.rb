class API::V1::ChatroomUsersController < ApplicationController

  def index
    chatroom_user = ChatroomUser.where(user_id: params[:user_id])
    @response_array = []
    chatroom_user.each do |chatroom_user|
      count = 0
      chatroom = chatroom_user.chatroom
      if chatroom.updated_at > chatroom_user.updated_at
        count = chatroom.messages.where("messages.updated_at > ?", chatroom_user.updated_at).count
      end
      opposed_user = chatroom_user.chatroom.chatroom_users.where("chatroom_users.user_id != ?", params[:user_id])
      response_hash = {chatroom: opposed_user.first.chatroom_id, user: opposed_user.first.user_id, unread_message: count}
      @response_array << response_hash
    end
    render json: @response_array
  end

end
