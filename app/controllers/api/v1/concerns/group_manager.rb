module API::V1::Concerns
  module GroupManager
    extend ActiveSupport::Concern

    def create
      @chatroom = @project.chatrooms.create(name: params[:name])
      chatroom_user = @chatroom.chatroom_users
      chatroom_user.create(user_id: params[:creator]).admin!
      add_member_in_scrum(params[:member])
      response_to(@chatroom, chatroom_user, :ok)
    end

    def remove_member
      chatroom_users = @chatroom.chatroom_users
      user = chatroom_users.find_by_id(params[:user_id])
      user.destroy if user.present?
      response_to(@chatroom, chatroom_users, :ok)
    end

    def add_member
      chatroom_users = @chatroom.chatroom_users
      add_member_in_scrum(params[:member])
      status = @status || :error
      response_to(@chatroom, chatroom_users, status)
    end

    def make_admin
      chatroom = @project.chatrooms.find_by(id: params['chatroom_id'])
      admin_operation(chatroom.chatroom_users, 'admin!')
    end

    def dismiss_admin
      chatroom = @project.chatrooms.find_by(id: params['chatroom_id'])
      admin_operation(chatroom.chatroom_users, 'user!')
    end

    protected

    def find_project
      @project = Project.find_project(params['auth']['public_key'])
    end

    def admin_operation(chatroom_users, operation)
      user = chatroom_users.find_by_id(params['user_id'])
      if user.present?
        user.send(operation)
        @status = :ok
      end
      status = @status || :error
      response_to(chatroom, chatroom_users, status)
    end

    def response_to(chatroom, members, status)
      render json: { data: { chatroom: chatroom, members: members } },
             status: status
    end

    def add_member_in_scrum(member)
      member.each do |user|
        chatroom_users = @chatroom.chatroom_users
        unless chatroom_users.exist?(user).present?
          chatroom_users.create(user_id: user)
          @status = :ok
        end
      end
    end
  end
end
