#!/usr/bin/env ruby

require 'socket'

PORT = 4567
if ARGV.length > 0
  PORT = ARGV[0].to_i
  if PORT == 0
    PORT = 4567
  end
end

def generate_response(data)
  "HTTP/1.1 200 OK\r\n" +
  "Content-Type: text/plain\r\n" +
  "Server: headerecho\r\n" +
  "Connection: close\r\n" +
  "Cache-Control: no-cache\r\n" +
  "Pragma: no-cache\r\n" +
  "Content-Length: #{data.length}\r\n" +
  "\r\n" +
  "#{data}"
end


puts "Starting server on 0.0.0.0:#{PORT}"
webserver = TCPServer.new('0.0.0.0', PORT)
loop do
  Thread.start(webserver.accept) do |socket|
    puts "Got a request! So exciting!"
    response_data = ""
    body_length = 0
    begin
      while (line = socket.gets)
        puts line
        response_data += line
        if line =~ /^Content-Length:\s+(\d+)/i
          body_length = $1.to_i
        end
        break if line == "\r\n"
      end
      response_data += socket.readpartial(body_length)
      socket.print generate_response(response_data)
      socket.flush
    rescue StandardError => e
      puts "Error handling request: #{e.inspect}"
    end
    socket.close
  end
end
puts "Server shutting down..."
