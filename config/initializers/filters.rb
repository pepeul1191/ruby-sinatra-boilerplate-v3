module Sinatra
  module App
    module Helpers
      module Filters
        def check_csrf
          if CONSTANTS[:ambiente_csrf] == 'activo' then
            csrf_key = 'HTTP_' + CONSTANTS[:csrf][:key].upcase
            csrf_val = CONSTANTS[:csrf][:secret]
            if request.env[csrf_key] != csrf_val then
              rpta = {
                :tipo_mensaje => 'error',
                :mensaje => [
                  'No se puede acceder al recurso',
                  'CSRF Token key error'
                ]}
              halt 500, rpta.to_json
            end
          end
        end

        def check_session_false
          if session[:activo] == true then
            halt redirect '/'
          end
        end

        def check_session_true
          if session[:activo] != true then
            halt redirect '/error/access/505'
          end
        end
      end
    end
  end
end
