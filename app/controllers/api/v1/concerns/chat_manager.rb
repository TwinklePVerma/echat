module API::V1::Concerns
  module ChatManager
    extend ActiveSupport::Concern
    
    def archive
      authenticate!
      if @chatroom.present?
        @chatroom.archived! 
        render json: {data: @chatroom},
                status: :ok
      end
      render json: {status: :error} if !@chatroom.present?
    end

    def active
      authenticate!
      if @chatroom.present?
        @chatroom.active!
        render json: {data: @chatroom},
                status: :ok
      end
      render json: {status: :error} if !@chatroom.present?
    end
  end
end