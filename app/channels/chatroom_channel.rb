class ChatroomChannel < ApplicationCable::Channel
  include CustomEncDec

  def subscribed
    project = Project.find_project($params[:public_key])
    chatroom_user = ChatroomUser.exist?($params[:uid]) if project.present?
    chatroom_user.each do |room|
      chatroom = room.chatroom
      stream_for chatroom.name if project == chatroom.project
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    message_params = make_message_data(data)
    Message.create(message_params)
  end

  protected

  def dec_message(ids, message)
    obj = CustomEncDec.new("DM:#{ids.join(':')}")
    obj.decrypt(message)
  end

  def make_message_data(data)
    message = data['message']
    ids = [message[2]['value'], message[0]['value']].sort
    message[3]['value'] = dec_message(ids, message[3]['value'])
    get_message_data(data)
  end

  def get_message_data(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el.values.first] = el.values.last if el.values.first != 'peer_id'
    end
    message_params
  end
end
