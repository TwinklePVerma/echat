class ApplicationController < ActionController::API
  include ActionController::MimeResponds 

  def authenticate!
    keys = params.require("auth").permit("public_key", "secret_key")
    @project = Project.find_by(public_key: keys[:public_key])
    
    obj = Crypt.new("#{keys[:public_key]}#{Rails.application.secrets.secret_key_base}")
    secret_key = obj.decrypt(@project.secret_key)

    if keys[:secret_key] == secret_key
      true
    else
      respond_to json: {status: 401, message: 'unauthorized access'},
            status: :error
    end
  end
end
