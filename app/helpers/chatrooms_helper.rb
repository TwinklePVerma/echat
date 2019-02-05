module ChatroomsHelper
  def unread_message_count(chatroom, chatroom_user)
    unread = 0
    last_read_at = chatroom_user.last_read_at
    if !last_read_at.nil? && chatroom.updated_at > last_read_at
      unread = chatroom.messages.where('messages.updated_at > ?', last_read_at)
      unread = unread.count
    end
    unread
  end
end
