class FindChat
  include ChatroomsHelper

  def initialize(params)
    @chatroom_user = ChatroomUser.exist?(params[:user_id])
  end

  def active_chat
    chat_helper('active?')
  end

  def archived_chat
    chat_helper('archived?')
  end

  protected

  def chat_helper(operation)
    @response_array = []
    return unless @chatroom_user.present?

    @chatroom_user.each do |user|
      chatroom = user.chatroom
      next unless chatroom.send(operation)

      count = unread_message_count(chatroom, user)
      make_response_hash(user, chatroom, count)
    end
    @response_array
  end

  def scrum_response(user, count)
    { id: user.chatroom.id,
      chatroom: user.chatroom.name,
      unread_message: count,
      direct_message: false }
  end

  def peer_response(opposed_user, count)
    { id: opposed_user.first.user_id,
      chatroom_id: opposed_user.first.chatroom.id,
      chatroom: opposed_user.first.chatroom.name,
      unread_message: count,
      direct_message: true }
  end

  def make_response_hash(user, chatroom, count)
    if chatroom.peer?
      opposed_user = chatroom.chatroom_users - [user]
      response_hash = peer_response(opposed_user, count)
    elsif chatroom.scrum?
      response_hash = scrum_response(user, count)
    end
    @response_array << response_hash
  end
end
