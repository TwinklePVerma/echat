class API::V1::ChatroomsController < ApplicationController
  include API::V1::Concerns::GroupManager
  include API::V1::Concerns::ChatManager

  before_action :authenticate!
  action = %i[create active_chat archived_chat make_admin dismiss_admin]
  before_action :find_chatroom, except: action

  respond_to :json

  swagger_controller :chatrooms, 'Chatroom'

  swagger_api :create do
    summary 'Create chatroom as a group'
    notes 'Notes...'
    param :form, :name, :string, :required, 'Chatroom name'
    param :form, :creator, :integer, :required, 'Admin Id'
    param :form, :member, :array, :required, 'Member Ids'
    response :ok, 'success'
    response :error, 'problem in creating chatroom'
  end

  swagger_api :show do
    summary 'Show chatroom details'
    notes 'Notes...'
    param :path, :id, :integer, :required, 'Chatroom Id'
    response :ok, 'success'
    response :error, 'no record found'
  end

  def show
    chatroom_users_data = []
    @chatroom.chatroom_users.each do |user|
      chatroom_users_data << user
    end
    render json: { data: { member_user: chatroom_users_data } },
           status: :ok
  end

  def destroy
    status = @chatroom.destroy ? :ok : :error
    render json: { status: status }
  end

  def active_chat
    response = FindChat.new(user_id: params[:user_id]).active_chat || :error
    render json: { data: response }
  end

  def archived_chat
    response = FindChat.new(user_id: params[:user_id]).archived_chat || :error
    render json: { data: response }
  end
end
