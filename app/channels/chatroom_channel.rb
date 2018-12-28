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
    if data['message'][0]['name'] == 'chatroom_status' && data['message'][0]['value'] == 'new'
      subscribed
    end

    message_params = data['message'].each_with_object({}) do |el, hash|
      if el.values.first != 'chatroom_status'
        hash[el.values.first] = el.values.last
      else
        next
      end
    end

    Message.create(message_params)
  end
end
