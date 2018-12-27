class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = []
    chatroom_user = ChatroomUser.where(user_id: $params[:uid])
    chatroom_user.each do |room|
      stream_for room.chatroom.name
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el.values.first] = el.values.last
    end

    Message.create(message_params)
  end
end
