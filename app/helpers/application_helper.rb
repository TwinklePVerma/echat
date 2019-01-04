# frozen_string_literal: true

module ApplicationHelper
  def unread_message_count(chatroom, chatroom_user)
    count = 0
    if chatroom.updated_at > chatroom_user.updated_at
      count = chatroom.messages.where("messages.updated_at > ?", chatroom_user.updated_at).count
    end
    return count
  end  
end
