class ChatroomUser < ApplicationRecord
  belongs_to :chatroom
  enum member_role: [ :user, :admin ]
end
