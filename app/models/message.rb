class Message < ApplicationRecord
  belongs_to :chatroom

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  after_create_commit :update_chatroom, :update_chatroom_user

  private

  def update_chatroom
    chatroom = self.chatroom
    chatroom.update(updated_at: Time.zone.now) if chatroom.present?
  end

  def update_chatroom_user
    chatroom = self.chatroom
    if chatroom.present?
      user = chatroom.chatroom_users.where(user_id: self.user_id)
      user.update(updated_at: Time.zone.now)
    end
  end
end
