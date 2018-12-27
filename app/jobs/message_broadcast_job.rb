class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    broadcast(message)
  end

  private

  def broadcast(message)
    ChatroomChannel.broadcast_to(message.chatroom.name, message)
  end
end
