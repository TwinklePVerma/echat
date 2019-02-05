class ChatroomUser < ApplicationRecord
  validates_presence_of :user_id, :member_role

  belongs_to :chatroom
  enum member_role: %i[user admin]

  scope :find_by_id, ->(id) { find_by(user_id: id) }
  scope :exist?, ->(id) { where(user_id: id) }

  after_create do
    update(last_read_at: Time.zone.now) if admin?
  end
end
