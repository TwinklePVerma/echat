class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = []
    project = Project.find_by(public_key: $params[:public_key])
    if project.present?
      chatroom_user = ChatroomUser.where(user_id: $params[:uid])
      chatroom_user.each do |room|
        if project == room.chatroom.project
          stream_for room.chatroom.name
        end
      end
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
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
