module Sinatra
  module App
    module Helpers
      module LoginHelper
        def login_css
          rpta = nil
          if CONSTANTS[:ambiente] == 'desarrollo'
            rpta = [
              'assets/css/styles',
              'assets/css/login',
            ]
          else
            rpta = [
              'dist/login.min',
            ]
          end
          rpta
        end

        def login_js
          rpta = nil
          if CONSTANTS[:ambiente] == 'desarrollo'
            rpta = [
            ]
          else
            rpta = [
            ]
          end
          rpta
        end
      end
    end
  end
end
