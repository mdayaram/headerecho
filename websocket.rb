#!/usr/bin/env ruby

require 'socket'
require './port'
require './header'

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
