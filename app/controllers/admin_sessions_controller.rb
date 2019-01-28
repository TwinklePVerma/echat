class AdminSessionsController < ActionController::Base

  def login
    if session[:id].present?
      redirect_to new_project_path
    end
  end

  def create
    if params[:user_id] == Rails.application.credentials.admin_credential[:user_id] && params[:password] == Rails.application.credentials.admin_credential[:password]
      session[:id] = params[:user_id]
      redirect_to new_project_path
    else
      redirect_to login_path
    end
  end

  def logout
    session[:id] = nil
    redirect_to login_path
  end
end
