class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  before_action :authenticate!

  def authenticate!
    keys = params.require('auth').permit('public_key', 'secret_key')
    project = Project.find_by(public_key: keys[:public_key])
    secret_key_base = Rails.application.secrets.secret_key_base
    dec_secret_key = secret_key(keys[:public_key], secret_key_base, project)
    if keys[:secret_key] == dec_secret_key
      true
    else
      respond_to json: { status: 401, message: 'unauthorized access' },
                 status: :error
    end
  end

  def secret_key(public_key, secret_key_base, project)
    obj = Crypt.new("#{public_key}#{secret_key_base}")
    obj.decrypt(project.secret_key)
  end
end
