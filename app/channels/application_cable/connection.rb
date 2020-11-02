module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # isolate users by session, as they connect on websocket
    identified_by :session_id

    def connect
      self.session_id = request.session.id
    end
  end
end
