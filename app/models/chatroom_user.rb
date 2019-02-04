class ChatroomUser < ApplicationRecord
  validates_presence_of :user_id, :member_role
  
  belongs_to :chatroom
  enum member_role: [ :user, :admin ]
end
