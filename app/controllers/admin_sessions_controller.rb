class AdminSessionsController < ActionController::Base
  before_action :find_admin_credentials, only: :create
  before_action :authenticate!, except: %i[login create logout]

  def login
    redirect_to new_project_path if session[:id].present?
  end

  def create
    if params[:user_id] == @user_id
      if params[:password] == @password
        session[:id] = params[:user_id]
        redirect_to new_project_path
      end
    else
      redirect_to login_path
    end
  end

  def logout
    session[:id] = nil
    redirect_to login_path
  end

  protected

  def find_admin_credentials
    @user_id = Rails.application.credentials.admin_credential[:user_id]
    @password = Rails.application.credentials.admin_credential[:password]
  end
end
