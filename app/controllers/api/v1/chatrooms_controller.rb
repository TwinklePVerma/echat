class API::V1::ChatroomsController < ApplicationController
  before_action :find_chatroom, only: [:destroy, :join]

  def create
    @chatroom = Chatroom.create(name: chatroom_params[:name])
    @chatroom.chatroom_users.create(user_id: chatroom_params[:self])
    if chatroom_params[:opposed_user].present?
      @chatroom.chatroom_users.create(user_id: chatroom_params[:opposed_user])
    end
    render json: @chatroom
  end

  def destroy
    @chatroom.destroy
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name, :opposed_user)
  end

  def find_chatroom
    @chatroom = Chatroom.find(params[:id])
  end
end