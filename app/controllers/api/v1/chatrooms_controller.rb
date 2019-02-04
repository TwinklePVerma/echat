# frozen_string_literal: true

class API::V1::ChatroomsController < ApplicationController
  include API::V1::Concerns::GroupManager
  include API::V1::Concerns::ChatManager

  before_action :find_chatroom, except: :create

  respond_to :json

  swagger_controller :chatrooms, 'Chatroom'

  swagger_api :create do
    summary 'Create chatroom as a group'
    notes 'Notes...'
    param :form, :name, :string, :required, "Chatroom name"
    param :form, :creator, :integer, :required, "Admin Id"
    param :form, :member, :array, :required, "Member Ids"
    response :ok, "success"
    response :error, "problem in creating chatroom"
  end

  swagger_api :show do
    summary 'Show chatroom details'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    response :ok, "success"
    response :error, "no record found"
  end

  def show
    authenticate!
    if @chatroom.present?
      chatroom_users_data = []
      chatroom_users = @chatroom.chatroom_users
      chatroom_users.each do |user|
        chatroom_users_data << user
      end
      render json: {data: {member_user: chatroom_users_data}},
              status: :ok
    else
      render json: {status: :error}
    end
  end

  swagger_api :destroy do
    summary 'Delete chatroom'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    response :ok, "success"
    response :error, "error"
  end

  def destroy
    authenticate!
    status = @chatroom.present? ?  (@chatroom.destroy ? :ok : :error) : :error
    render json: {status: status}
  end

  swagger_api :add_member do
    summary 'Add members to group chatroom'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    param :query, :member, :array, :required, "User ids"
    response :ok, "success"
    response :error, "error"
  end

  swagger_api :remove_member do
    summary 'remove member to group chatroom'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    param :path, :user_id, :integer, :required, "Member id"
    response :ok, "success"
    response :error, "error"
  end

  swagger_api :active_chat do
    summary 'Return active chats of user'
    notes 'Notes...'
    param :query, :user_id, :integer, :required, "User id"
    response :ok, "success"
    response :error, "no record found"
  end

  def active_chat
    authenticate!
    @response = FindChat.new(user_id: params[:user_id]).active_chat
    if @response.present?
      render json: {data: @response}, 
              status: :ok
    else
      render json: { status: :error }
    end
  end

  swagger_api :archived_chat do
    summary 'Return archive chats of user'
    notes 'Notes...'
    param :query, :user_id, :integer, :required, "User id"
    response :ok, "success"
    response :error, "no record found"
  end

  def archived_chat
    authenticate!
    @response = FindChat.new(user_id: params[:user_id]).archived_chat
    if @response.present?
      render json: {data: @response},
              status: :ok
    else
      render json: { status: :error }
    end
  end

  swagger_api :archive do
    summary 'Update chatroom status'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    response :ok, "success"
    response :error, "error"
  end

  swagger_api :active do
    summary 'Update chatroom status'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    response :ok, "success"
    response :error, "error"
  end

  private

  def find_chatroom
    @chatroom = Chatroom.find_by(id: params[:id])
  end

end