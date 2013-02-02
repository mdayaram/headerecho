#!/usr/bin/env ruby

require 'socket'
require 'optparse'

options = { :port => 4567 }
OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
  opts.on("-p", "--port N", Integer, "Port to start the server on, default is 4567") do |port|
    options[:port] = port
  end
end.parse!

class RequestLogger
  def initialize
    log("Got a request! How exciting!")
  end

  def log(msg)
    puts "rq[#{object_id}]: #{msg}"
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


puts "Starting server on 0.0.0.0:#{options[:port]}"
webserver = TCPServer.new('0.0.0.0', options[:port])

loop do
  Thread.start(webserver.accept) do |socket|

    logger = RequestLogger.new
    response_data = ""
    body_length = 0

    begin
      while (line = socket.gets)
        response_data += line
        if line =~ /^Content-Length:\s+(\d+)/i
          body_length = $1.to_i
        end
        break if line == "\r\n"
      end

      logger.log "Request length: #{body_length}"
      response_data += socket.readpartial(body_length)
      socket.print generate_response(response_data)
    rescue StandardError => e
      logger.log "Error handling request: #{e.inspect}"
    end
    logger.log("Completed request.")
    socket.close
  end
end
puts "Server shutting down..."
