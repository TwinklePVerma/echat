class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :chatroom_users, dependent: :destroy
end
