#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

helpers do
  def request_headers
    env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
  end  
end

get '*' do
  return "Request Headers:\n\n\n" + request_headers.inspect
end
