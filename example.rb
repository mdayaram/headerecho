require 'socket'
require './port'

socket = TCPServer.new('0.0.0.0', "#{PORT}")
socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
loop do
  client = socket.accept
  data = ''
  loop do
    event = select([client],nil,nil,0.5)
    if client.eof? # Socket's been closed by the client
      # puts "Connection closed"
      # client.close
      break
    else
      begin
        if client.respond_to?(:read_nonblock)
          10.times {
            data << client.read_nonblock(4096)
          }
        else
          data << client.sysread(4096)
        end
      rescue Errno::EAGAIN, Errno::EWOULDBLOCK => e
        # no-op. This will likely happen after every request, but that's expected. It ensures that we're done with the request's data.
      rescue Errno::ECONNRESET, Errno::ECONNREFUSED, EOFError => e
        # puts "Closed Err: #{e.inspect}"; $stdout.flush
      end
    end
  end
  puts "Web Browser said:\n\n#{data}"
  client.puts "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n<h1>Hello World!</h1>"
  client.close
end
socket.close
