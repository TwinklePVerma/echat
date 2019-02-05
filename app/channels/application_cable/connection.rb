module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
      $params = request.query_parameters
      self.uuid = if $params[:uid] && $params[:uname]
                    $params[:uname]
                  else
                    reject_unauthorized_connection
                  end
    end
  end
end
