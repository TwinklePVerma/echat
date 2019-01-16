# frozen_string_literal: true

class Chatroom < ApplicationRecord
  enum status: [ :active, :archived ]

  has_many :messages, dependent: :destroy
  has_many :chatroom_users, dependent: :destroy

  def peer?
    if self.direct_message == true
      true
    else
      false
    end
  end

  def scrum?
    if self.direct_message == false
      true
    else
      false
    end
  end

  def self.direct_message_for_users(users)
    user_ids = users.sort
    name = "DM:#{user_ids.join(":")}"

    if chatroom = where(name: name, direct_message: true).first
      chatroom
    else
      chatroom = new(name: name, direct_message: true)
      users.each do |user|
        chatroom.chatroom_users.new(user_id: user)
      end
      chatroom.save
      chatroom
    end
  end
end
