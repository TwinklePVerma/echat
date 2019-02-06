class API::V1::MessagesController < ApplicationController
  before_action :authenticate!
  before_action :find_chatroom, except: %i[destroy update]
  before_action :find_message, only: %i[destroy update]
  after_action :update_chatroom_user, :update_chatroom

  swagger_controller :messages, 'Message'

  swagger_api :index do
    summary 'Return messages'
    notes 'Notes...'
    param :query, :receiver, :integer, :required, 'Receiver Id'
    param :query, :type, :integer, :optional, 'Chatroom type'
    param :query, :sender, :integer, :required, 'Sender Id'
    response :ok, 'success'
    response :error, 'problem in creating chatroom'
  end

  def index
    messages = [{ chatroom_id: @chatroom.id, body: 'Not chatted yet' }]
    message = @chatroom.messages
    messages = message if message.present?
    render json: { data: { message: messages, scrum_name: @chatroom.name } },
           status: :ok
  end

  swagger_api :update do
    summary 'Update message text'
    notes 'Notes...'
    param :path, :id, :integer, :required, 'Message Id'
    param :query, :message, :string, :required, 'Message text'
    response :ok, 'success'
    response :error, 'problem in creating chatroom'
  end

  def update
    @message.update(data: params[:message])
    render json: { data: @message },
           status: :ok
  end

  swagger_api :destroy do
    summary 'delete message'
    notes 'Notes...'
    param :path, :id, :integer, :required, 'Message Id'
    response :ok, 'success'
    response :error, 'problem in creating chatroom'
  end

  def destroy
    @message.destroy
    render json: { data: @message },
           status: :ok
  end

  protected

  def find_message
    @message = Message.find_by(id: params[:id])
    @message.present? ? true : (render json: { status: :error })
  end

  def update_chatroom
    @chatroom.update(updated_at: Time.zone.now)
  end

  def update_chatroom_user
    user = @chatroom.chatroom_users.exist?(params[:sender])
    user.update(last_read_at: Time.zone.now) if user.present?
  end
end
