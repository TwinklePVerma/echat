module API::V1::Concerns
  module ChatManager
    extend ActiveSupport::Concern

    included do
      before_action :find_chatroom, except: %i[archive active]
    end

    def archive
      chat_type(:archived!)
    end

    def active
      chat_type(:active!)
    end

    protected

    def chat_type(method)
      authenticate!
      if @chatroom.present?
        @chatroom.send(method)
        render json: { data: @chatroom },
               status: :ok
      else
        render json: { status: :error }
      end
    end
  end
end
