# frozen_string_literal: true

class API::V1::ChatroomsController < ApplicationController
  before_action :find_chatroom, only: [:destroy, :update, :add_member, :remove_member, :show]

  respond_to :json

  swagger_controller :chatrooms, 'Chatroom'

  swagger_api :create do
    summary 'Create chatroom as a group'
    notes 'Notes...'
    param :form, :name, :string, :required, "Chatroom name"
    param :form, :member, :array, :required, "Member Ids"
    response :ok, "success"
    response :error, "problem in creating chatroom"
  end
  
  def create
    if params[:member].present? && params[:name].present?
      @chatroom = Chatroom.create(name: params[:name], direct_message: false)
      # params[:member].split(',').each do |member_id|        #swagger
      params[:member].each do |member_id|                     #api
        @chatroom.chatroom_users.create(user_id: member_id, last_read_at: Time.now)
      end
      render json: {data: @chatroom, status: :ok}
    else
      render json: {status: :error}
    end
  end

  swagger_api :update do
    summary 'Update chatroom status'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    response :ok, "success"
    response :error, "error"
  end

  def update
    if @chatroom.active?
      @chatroom.archived!
    else
      @chatroom.active!
    end if @chatroom.present?
    render json: {data: @chatroom, status: :ok} if @chatroom.present?
    render json: {status: :error} if !@chatroom.present?
  end

  swagger_api :show do
    summary 'Show chatroom details'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    response :ok, "success"
    response :error, "no record found"
  end

  def show
    if @chatroom.present?
      chatroom_users_data = []
      chatroom_users = @chatroom.chatroom_users
      chatroom_users_data_temp = {}
      chatroom_users.each do |user|
        chatroom_users_data << user.user_id
      end
      render json: {data: {member_user: chatroom_users_data}, status: :ok}
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
    if @chatroom.present?
      @chatroom.destroy
      render json: {status: :ok}
    else
      render json: {status: :error}
    end
  end

  swagger_api :add_member do
    summary 'Add members to group chatroom'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    param :query, :member, :array, :required, "User ids"
    response :ok, "success"
    response :error, "error"
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
    render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}, status: status}
  end

  swagger_api :remove_member do
    summary 'remove member to group chatroom'
    notes 'Notes...'
    param :path, :id, :integer, :required, "Chatroom Id"
    param :path, :user_id, :integer, :required, "Member id"
    response :ok, "success"
    response :error, "error"
  end

  def remove_member
    if @chatroom.present?
      chatroom_user = @chatroom.chatroom_users.find_by(user_id: params[:user_id])
      if chatroom_user.present?
        chatroom_user.destroy
      end
      render json: {data: {chatroom: @chatroom, members: @chatroom.chatroom_users}, status: :ok}
    else
      render json: {status: :error}
    end
  end

  swagger_api :active_chat do
    summary 'Return active chats of user'
    notes 'Notes...'
    param :query, :user_id, :integer, :required, "User id"
    response :ok, "success"
    response :error, "no record found"
  end

  def active_chat
    @response = FindChat.new(user_id: params[:user_id]).active_chat
    if @response.present?
      render json: {data: @response, status: :ok}
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
    @response = FindChat.new(user_id: params[:user_id]).archived_chat
    if @response.present?
      render json: {data: @response, status: :ok}
    else
      render json: { status: :error }
    end
  end

  private

  def find_chatroom
    @chatroom = Chatroom.find_by(id: params[:id])
  end

end