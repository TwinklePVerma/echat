module API::V1::Concerns
  module GroupManager
    extend ActiveSupport::Concern
    
    def create
      authenticate!
      if params[:member].present? && params[:name].present? && params[:creator]
        @chatroom = @project.chatrooms.create(name: params[:name], direct_message: false)
        # params[:member].split(',').each do |member_id|        #swagger
        @chatroom.chatroom_users.create(user_id: params[:creator], last_read_at: Time.now).admin!
        params[:member].each do |member_id|                     #api
          @chatroom.chatroom_users.create(user_id: member_id, last_read_at: Time.now)
        end
        render json: {data: @chatroom}, 
                status: :ok
      else
        render json: {status: :error}
      end
    end

    def remove_member
      authenticate!
      if @chatroom.present?
        chatroom_user = @chatroom.chatroom_users.find_by(user_id: params[:user_id])
        chatroom_user.destroy if chatroom_user.present?
        render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
                status: :ok
      else
        render json: {status: :error}
      end
    end

    def add_member
      authenticate!
      # params[:member].split(',').each do |user|        #swagger
      params[:member].each do |user|                     #api
        if @chatroom.chatroom_users.find_by(user_id: user).present?
          @status = :error
        else
          @chatroom.chatroom_users.create(user_id: user)
          @status = :ok
        end
      end
      render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
              status: @status
    end

    def make_admin
      admin_operation('admin!')
    end

    def dismiss_admin
      admin_operation('user!')
    end

    protected
    
    def admin_operation operation
      authenticate!
      @chatroom = Chatroom.find_by(id: params["chatroom_id"])
      chatroom_user = ChatroomUser.find_by(user_id: params["user_id"], chatroom_id: params["chatroom_id"])
      status = chatroom_user.present? ? (chatroom_user.send(operation) ? :ok : :error) : :error
      render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
              status: status
    end
  end
end