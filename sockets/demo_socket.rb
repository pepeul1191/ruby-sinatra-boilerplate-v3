module Sinatra
  module App
    module Socket
      module Demo
        def self.registered(app)
          #filters
          app.before ['/demo', ] do
            #check_session_true
          end
          #handlers
          demo = lambda do
            if !request.websocket?
              erb :index
            else
              request.websocket do |ws|
                ws.onopen do
                  ws.send("Hello World!")
                  settings.sockets << ws
                end
                ws.onmessage do |msg|
                  EM.next_tick do
                    settings.sockets.each do |s|
                      s.send(msg)
                    end
                  end
                end
                ws.onclose do
                  warn("websocket closed")
                  settings.sockets.delete(ws)
                end
              end
            end
          end
          #routes
          app.get  '/demo', &demo
        end
      end
    end
  end
end
