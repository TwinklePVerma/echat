class AddDirectMessageToChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :chatrooms, :direct_message, :integer, default: 0
  end
end
