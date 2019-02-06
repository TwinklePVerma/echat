class API::V1::DirectMessagesController < ApplicationController
  before_action :authenticate!
  after_action :update_chatroom_user, :update_chatroom
  before_action :find_chatroom, except: %i[index]

  def index
    users = [params[:sender], params[:receiver]]
    @chatroom = Chatroom.direct_message_for_users(users)
    @messages = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet' }]
    @messages = @chatroom.messages if @chatroom.messages.present?
    render json: { data: { message: @messages, peer_id: params[:receiver] } },
           status: :ok
  end

  protected

  def update_chatroom
    @chatroom.update(updated_at: Time.zone.now) if @chatroom.present?
  end

  def update_chatroom_user
    return unless @chatroom.present?

    @user = @chatroom.chatroom_users.exist?(params[:sender])
    @user.update(last_read_at: Time.zone.now) if @user.present?
  end
end
