class AddRoleToChatroomUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :chatroom_users, :member_role, :integer, default: 0
  end
end