# frozen_string_literal: true

class Chatroom < ApplicationRecord
  enum status: { active: 0, archived: 1 }
  enum direct_message: { peer: true, scrum: false}
  has_many :messages, dependent: :destroy
  has_many :chatroom_users, dependent: :destroy
end
