class MessageBroadcastJob < ApplicationJob
  include ::CustomEncDec
  queue_as :default

  def perform(message)
    key = message.chatroom.name
    obj = CustomEncDec.new(key)
    message.body = obj.encrypt(message.body)
    broadcast(message)
  end

  private

  def broadcast(message)
    data = { message: message, chatroom_name: message.chatroom.name }
    ChatroomChannel.broadcast_to(message.chatroom.name, data)
  end
end
