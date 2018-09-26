require 'net/smtp'

module Sinatra
  module App
    module Helpers
      module Mail
        def mail_send_password(user)
          message = """
          From: Soporte Software Web Perú <soporte@softweb.pe>
          To: """ + user.name + '<' + user.email + '>' + """
          MIME-Version: 1.0
          Content-type: text/html
          Subject: SMTP e-mail test

          This is an e-mail message to be sent in HTML format

          <b>This is HTML message.</b>
          <h1>This is headline.</h1>
          """
          Net::SMTP.start('mail.softweb.pe', 
              25, 
              'localhost', 
              'epe@softweb.pe', 'instructor.epe.123', :plain
            ) do |smtp|
              smtp.send_message message, 'soporte@softweb.pe', user.email
          end
        end
      end
    end
  end
end