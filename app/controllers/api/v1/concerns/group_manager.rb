module API::V1::Concerns
  module GroupManager
    extend ActiveSupport::Concern
    
    def create
      if params[:member].present? && params[:name].present? && params[:creator]
        @chatroom = Chatroom.create(name: params[:name], direct_message: false)
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
      if @chatroom.present?
        chatroom_user = @chatroom.chatroom_users.find_by(user_id: params[:user_id])
        if chatroom_user.present?
          chatroom_user.destroy
        end
        render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
                status: :ok
      else
        render json: {status: :error}
      end
    end

    def add_member
      # params[:member].split(',').each do |user|        #swagger
      params[:member].each do |user|                     #api
        status = ''
        if @chatroom.chatroom_users.find_by(user_id: user).present?
          status = :error
        else
          @chatroom.chatroom_users.create(user_id: user)
          status = :ok
        end
      end
      render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
              status: status
    end

    def make_admin
      status = :error
      @chatroom = Chatroom.find_by(id: params["chatroom_id"])
      if ChatroomUser.find_by(user_id: params["user_id"], chatroom_id: params["chatroom_id"]).admin!
        status = :ok
      end
      render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
              status: status
    end

    def dismiss_admin
      status = :error
      @chatroom = Chatroom.find_by(id: params["chatroom_id"])
      if ChatroomUser.find_by(user_id: params["user_id"], chatroom_id: params["chatroom_id"]).user!
        status = :ok
      end
      render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}},
              status: status
    end
  end
end