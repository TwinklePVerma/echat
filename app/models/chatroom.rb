# frozen_string_literal: true

class Chatroom < ApplicationRecord
  validates_presence_of :name, :status, :project_id
  validates_inclusion_of :direct_message, in: [true, false]

  enum status: [ :active, :archived ]

  has_many :messages, dependent: :destroy
  has_many :chatroom_users, dependent: :destroy
  belongs_to :project

  def peer?
    self.direct_message ? true : false
  end

  def scrum?
    self.direct_message ? false : true
  end

  def self.direct_message_for_users(users)
    user_ids = users.sort
    name = "DM:#{user_ids.join(":")}"

    chatroom = find_by(name: name, direct_message: true) ? find_by(name: name, direct_message: true) : connect_to_peer(name, users)
    return chatroom
  end

  protected
  
  def self.connect_to_peer(name, users)
    chatroom = new(name: name, direct_message: true, project_id: 2)
    users.each do |user|
      chatroom.chatroom_users.new(user_id: user)
    end
    chatroom.save
    return chatroom
  end
end
