#!/usr/bin/env ruby

require 'socket'
require './port'
require './header'

puts "Starting server on localhost:#{PORT}"
webserver = TCPServer.new('localhost', PORT)
loop do
  Thread.start(webserver.accept) do |socket|
    puts "Got a request! So exciting!"
    begin
      response_data = ""
      while socket
        line = socket.gets("\0") || break
        puts line
        response_data += line
      end
      socket.print generate_response(response_data)
      socket.flush
    rescue StandardError => e
      puts "Error handling request: #{e.inspect}"
    end
    socket.close
  end
end
puts "Server shutting down..."
