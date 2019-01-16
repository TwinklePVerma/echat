class ChangeDirectMessageToBeBooleanInChatroom < ActiveRecord::Migration[5.2]
  def up
    change_column :chatrooms, :direct_message, :boolean, default: true
  end

  def down
    change_column :chatrooms, :direct_message, :integer, default: 0
  end
end
