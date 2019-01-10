class ChangeDirectMessageToBeBooleanInChatroom < ActiveRecord::Migration[5.2]
  def change
    change_column :chatrooms, :direct_message, :boolean, default: true
  end
end
