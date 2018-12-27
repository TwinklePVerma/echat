class CreateChatroomUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :chatroom_users do |t|
      t.integer :user_id
      t.references :chatroom, foreign_key: true
      t.timestamps
    end
  end
end
