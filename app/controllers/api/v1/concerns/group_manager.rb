module API::V1::Concerns
  module GroupManager
    extend ActiveSupport::Concern

    included do
      before_action :find_project, only: %i[create]
    end

    def create
      if params[:member].present? && params[:name].present? && params[:creator]
        @chatroom = @project.chatrooms.create(name: params[:name])
        @chatroom.scrum!
        @chatroom.chatroom_users.create(user_id: params[:creator]).admin!
        add_member_in_scrum(params[:member])
        response_to(@chatroom, @chatroom.chatroom_users, :ok)
        return
      end
      render json: { status: :error }
    end

    def remove_member
      if @chatroom.present?
        chatroom_users = @chatroom.chatroom_users
        user = @chatroom.chatroom_users.find_by_id(params[:user_id])
        user.destroy if user.present?
        response_to(@chatroom, chatroom_users, :ok)
      else
        render json: { status: :error }
      end
    end

    def add_member
      chatroom_users = @chatroom.chatroom_users
      add_member_in_scrum(params[:member])
      status = @status || :error
      response_to(@chatroom, chatroom_users, status)
    end

    def make_admin
      admin_operation('admin!')
    end

    def dismiss_admin
      admin_operation('user!')
    end

    protected

    def find_project
      @project = Project.find_project(params["auth"]["public_key"])
    end

    def admin_operation(operation)
      @chatroom = Chatroom.find_by(id: params['chatroom_id'])
      user = @chatroom.chatroom_users.find_by_id(params['user_id'])
      chatroom_users = @chatroom.chatroom_users
      if user.present?
        user.send(operation)
        @status = :ok
      end
      status = @status || :error
      response_to(@chatroom, chatroom_users, status)
    end

    def response_to(chatroom, members, status)
      render json: { data: { chatroom: chatroom, members: members } },
             status: status
    end

    def add_member_in_scrum(member)
      member.each do |user|
        unless @chatroom.chatroom_users.exist?(user).present?
          @chatroom.chatroom_users.create(user_id: user)
          @status = :ok
        end
      end
    end
  end
end
