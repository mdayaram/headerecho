#!/usr/bin/env ruby

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
