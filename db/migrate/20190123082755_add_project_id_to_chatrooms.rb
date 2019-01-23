class AddProjectIdToChatrooms < ActiveRecord::Migration[5.2]
  def change
    add_reference :chatrooms, :project, foreign_key: true
  end
end
