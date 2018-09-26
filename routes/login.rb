module Sinatra
  module App
    module Routing
      module Login
        def self.registered(app)
          #filters
          app.before ['/login',] do
            check_session_false
          end
          app.before ['/login/ver',] do
            check_session_true
          end
          #handlers
          index = lambda do
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Bienvenido',
              :mensaje => ''
            }
        		erb :'login/index', :layout => :'layouts/blank', :locals => locals
          end

          forgot_password = lambda do
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Recuperar Contraseña',
              :mensaje => ''
            }
        		erb :'login/forgot_password', :layout => :'layouts/blank', :locals => locals
          end

          sign_in = lambda do
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Crear cuenta',
              :mensaje => ''
            }
        		erb :'login/sign_in', :layout => :'layouts/blank', :locals => locals
          end

          ver = lambda do
            rpta = ''
            status = 200
            begin
            rpta = rpta + 'estado : ' + session[:activo].to_s + '<br>'
            rpta = rpta + 'momento : ' + session[:momento].to_s + '<br>'
            rpta = rpta + 'usuario : ' + session[:usuario] + '<br>'
            rescue TypeError => e
              execption = e
              status = 500
              rpta = {
                :tipo_mensaje => 'error',
                :mensaje => [
                  'Se ha producido un error en mostrar los datos de la sesión',
                  execption.message
                ]}.to_json
            end
            status status
            rpta
          end

          acceder = lambda do
            mensaje = ''
            continuar = true
            csrf_key = CONSTANTS[:csrf][:key]
            csrf_val = CONSTANTS[:csrf][:secret]
            csrf_req = params[csrf_key]
            if csrf_req == '' then
              mensaje = 'Token CSRF no existe en POST request'
              continuar = false
            else
              # validar csrf token
              if csrf_req != csrf_val then
                mensaje = 'Token CSRF no coincide en POST request'
                continuar = false
              end
              # validar usuario y contraseña si csrf token es correcto
              if continuar == true then
                usuario = params['usuario']
                contrasenia = params['contrasenia']
                if usuario != CONSTANTS[:login][:usuario] or contrasenia != CONSTANTS[:login][:contrasenia] then
                  mensaje = 'Usuario y/o contraenia no coinciden'
                  continuar = false
                end
              end
            end
            if continuar == true then
              session[:activo] = true
              session[:momento] = Time.now
              session[:usuario] = usuario
              redirect '/accesos/'
            else
              locals = {
                :constants => CONSTANTS,
                :csss => login_css(),
                :jss => login_js(),
                :title => 'Bienvenido',
                :mensaje => mensaje
              }
          		erb :'login/index', :layout => :'layouts/blank', :locals => locals
            end
          end

          cerrar = lambda do
            session.clear
            redirect '/login'
          end
          #routes
          app.get  '/login', &index
          app.get  '/login/forgot_password', &forgot_password
          app.get  '/login/sign_in', &sign_in
          app.post '/login/acceder', &acceder
          app.get  '/login/ver', &ver
          app.get  '/login/cerrar', &cerrar
        end
      end
    end
  end
end
