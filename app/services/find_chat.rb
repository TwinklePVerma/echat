class FindChat
  include ChatroomsHelper

  def initialize(params)
    @chatroom_user = ChatroomUser.where(user_id: params[:user_id])
  end

  def active_chat
    @response_array = []
    @chatroom_user.each do |user|
      chatroom = user.chatroom
      if chatroom.active?
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
    return @response_array
  end

  def archived_chat
    @response_array = []
    @chatroom_user.each do |user|
      chatroom = user.chatroom
      if chatroom.archived?
        count = unread_message_count(chatroom, user)
        if chatroom.archived?
          opposed_user = chatroom.chatroom_users - [user]
          response_hash = {id: opposed_user.first.user_id, chatroom: opposed_user.first.chatroom_id, unread_message: count}
        elsif chatroom.scrum?
          response_hash = {id: user.chatroom.id, chatroom: user.chatroom.name, unread_message: count}
        end              
        @response_array << response_hash
      end
    end
    return @response_array   
  end
end