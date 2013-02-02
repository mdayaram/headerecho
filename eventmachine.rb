#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'
require './port'
require './header'

class RequestHandler < EM::Connection
  attr_accessor :request
  def post_init
    puts "* Request initiated"
  end

  def receive_data data
    puts "* Getting Request data:"
    puts "   | #{data.split("\n").join("\n   | ")}"
    send_data generate_response(data)
    close_connection_after_writing
  end

  def unbind
    puts "* closing request"
  end
end

EventMachine::run {
  Signal.trap("INT") { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }

  EventMachine::start_server "127.0.0.1", PORT, RequestHandler
  puts "running echo server on #{PORT}"
}
