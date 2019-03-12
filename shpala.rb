require 'byebug'
require 'socket'
require 'cgi'
require_relative 'routes'

server = TCPServer.new('localhost', 3000)
STDOUT.puts('Ruby on Sleepers web server listening on http://localhost:3000')

loop do
  socket = server.accept
  request = socket.gets

  http_type = request.split(' ')[0]
  http_url = request.split(' ')[1][1..-1]

  path = http_url.split('?')[0]
  params_string = http_url.split('?')[1]

  STDOUT.puts(http_type)
  STDOUT.puts(http_url)

  if params_string
    params = CGI::parse(params_string)
    params.each { |k, v| params[k] = v[0] }

    STDOUT.puts('Request params:')
    STDOUT.puts(params)
  end

  controller_method = SHPALA_ROUTES["#{http_type}+#{path}"]

  if controller_method
    controller = controller_method.split('#')[0]
    method = controller_method.split('#')[1]

    STDOUT.puts("Controller: #{controller}##{method}")
    
    Dir['./controllers/*_controller.rb'].each do |file|
      require_relative file
    end

    begin
      controller_klass = Object::const_get(controller)
      ctrl = controller_klass.new
      ctrl.action(method, params)
      response = ctrl.response
    rescue Exception => e
      STDERR.puts(e)
      STDERR.puts(e.backtrace.join("\n"))
      response = '<h1>500 error</h1>'
    end
  else
    response = '<h1>404 error</h1>'
  end

  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/html\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  socket.print "\r\n"
  socket.print response
  socket.close
end

