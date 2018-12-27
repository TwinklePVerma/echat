module ApplicationHelper
  def unreadcount
    @count = 0
    chatroom_user = ChatroomUser.where(user_id: params[:id])
    chatroom_user.each do |user|
      chatroom = user.chatroom
      if chatroom.updated_at > user.updated_at
        @count = chatroom.messages.where("messages.updated_at > ?", user.updated_at).count
      end
    end
    render json: @count
  end
end
