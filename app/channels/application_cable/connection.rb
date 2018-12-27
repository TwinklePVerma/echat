module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
      $params = request.query_parameters()
      if $params[:uid] && $params[:uname]
        self.uuid = $params[:uname]
      else
        self.uuid = reject_unauthorized_connection
      end
    end
  end
end
