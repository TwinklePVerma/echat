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
end
