require 'securerandom'

class ProjectsController < ActionController::Base
  include ProjectHelper

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(name: project_params["name"])
    @project.public_key = SecureRandom.hex(10)
    @project.secret_key = generate_secret_key(@project.public_key)
    @project.save

    redirect_to project_path(@project)
  end

  def update
    @project = Project.find(params[:id])
    @project.update(secret_key: generate_secret_key(@project.public_key))

    redirect_to project_path(@project)
  end

  def show
    @project = Project.find(params[:id])
    obj = Crypt.new("#{@project.public_key}#{Rails.application.secrets.secret_key_base}")
    secret_key = obj.decrypt(@project.secret_key)
    @project = {id: @project.id, name: @project.name, public_key: @project.public_key, secret_key: secret_key}
  end

  protected

  def project_params
    params.require("project").permit("name")
  end
end
