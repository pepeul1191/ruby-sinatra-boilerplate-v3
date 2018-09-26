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
            mensaje_tipo = 'mensaje-error'
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Bienvenido',
              :mensaje => '',
              :mensaje_tipo => mensaje_tipo
            }
        		erb :'login/index', :layout => :'layouts/blank', :locals => locals
          end

          forgot_password = lambda do
            mensaje_tipo = 'mensaje-error'
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Recuperar Contraseña',
              :mensaje => '',
              :mensaje_tipo => mensaje_tipo
            }
        		erb :'login/forgot_password', :layout => :'layouts/blank', :locals => locals
          end

          sign_in = lambda do
            mensaje_tipo = 'mensaje-error'
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Crear cuenta',
              :mensaje => '',
              :mensaje_tipo => mensaje_tipo,
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

          access = lambda do
            mensaje = ''
            mensaje_tipo = 'mensaje-error'
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
                usuario = params['user']
                contrasenia = params['password']
                user = Models::User.where(:user => usuario, :password => contrasenia).first()
                if user == nil then
                  mensaje = 'Usuario y/o contraenia no coinciden'
                  continuar = false
                end
              end
            end
            if continuar == true then
              session[:activo] = true
              session[:momento] = Time.now
              session[:usuario] = usuario
              session[:user_id] = user.id
              redirect '/'
            else
              locals = {
                :constants => CONSTANTS,
                :csss => login_css(),
                :jss => login_js(),
                :title => 'Bienvenido',
                :mensaje => mensaje,
                :mensaje_tipo => mensaje_tipo,
              }
          		erb :'login/index', :layout => :'layouts/blank', :locals => locals
            end
          end

          send_password = lambda do
            mensaje = ''
            mensaje_tipo = 'mensaje-error'
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
                email = params['email']
                contrasenia = params['password']
                user_email = Models::User.select(:email).where(:email => email).first()
                if user_email == nil then
                  mensaje = 'Correo electrónico no registrado'
                  continuar = false
                else
                  #enviar correo
                  mensaje = 'Contraseña enviada'
                  mensaje_tipo = 'mensaje-success'
                end
              end
            end
            locals = {
              :constants => CONSTANTS,
              :csss => login_css(),
              :jss => login_js(),
              :title => 'Recuperar Contraseña',
              :mensaje => mensaje,
              :mensaje_tipo => mensaje_tipo,
            }
            erb :'login/forgot_password', :layout => :'layouts/blank', :locals => locals
          end

          cerrar = lambda do
            session.clear
            redirect '/login'
          end
          #routes
          app.get  '/login', &index
          app.get  '/login/forgot_password', &forgot_password
          app.get  '/login/sign_in', &sign_in
          app.get  '/login/ver', &ver
          app.get  '/login/cerrar', &cerrar
          app.post '/login/access', &access
          #app.post '/login/create_account', &create_account
          app.post '/login/send_password', &send_password
        end
      end
    end
  end
end
